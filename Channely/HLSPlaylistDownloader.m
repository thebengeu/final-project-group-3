//
//  HLSDownloader.m
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSPlaylistDownloader.h"

static NSTimeInterval const kRefreshInterval = 9.0; // Time in seconds.
static NSUInteger const kStreamTimeoutFactor = 10; // No. intervals before concluding timeout.
static NSString *const kHLSTargetDurationPrefix = @"#EXT-X-TARGETDURATION:";
static NSString *const kHLSEndListPrefix = @"#EXT-X-ENDLIST";
static NSString *const kHLSChunkPrefix = @"#EXTINF:";
static NSString *const kHLSMetaPrefix = @"#";
static NSString *const kMediaDirectoryFormat = @"%@";

@interface HLSPlaylistDownloader ()
// Redefinitions.
@property (atomic, readwrite) BOOL isConsumed;

// Internal.
@property (strong) NSURL *_baseURL;
@property (strong) NSString *_playlistFileName;
@property (strong) NSString *_playlistName;
@property (strong) NSString *_mediaDirectory;
@property (strong) id<HLSPlaylistDownloaderDelegate> _delegate;
@property (atomic) BOOL _error;

// Playlist Refresh.
@property (strong) NSTimer *_refreshTimer;
@property (strong) NSString *_oldPlaylist;
@property (atomic) NSUInteger _oldPlaylistHash;
@property (strong) NSString *_curPlaylist;
@property (atomic) BOOL _shouldFinishWhenQueueEmpty;
@property (strong) NSURL *_playlistURL;
@property (atomic) NSUInteger _intervalsSinceLastChange;
- (void)setupPlaylistRefresh;
- (void)refreshTimer_Tick:(NSTimer *)timer;
- (BOOL)parsePartialPlaylist:(NSString *)diff;
- (CGFloat)chunkDurationFromInfString:(NSString *)inf;
- (NSUInteger)targetDurationFromInfString:(NSString *)inf;

// Chunk Download.
@property (strong) NSOperationQueue *_downloadQueue;
@property (atomic) NSUInteger _chunkSequenceNumber;
- (void)setupDownloadQueue;
- (void)addURLToDownloadQueue:(NSURL *)url duration:(CGFloat)length;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

// Local HLS Generation.
@property (strong) NSString *_playlistDirectory;
@property (strong) HLSEventPlaylistHelper *_playlistHelper;

// Utility.
- (void)stopOperationWithError;

@end

@implementation HLSPlaylistDownloader
// Redefinitions.
@synthesize isConsumed;

// Internal.
@synthesize _baseURL;
@synthesize _playlistFileName;
@synthesize _playlistName;
@synthesize _mediaDirectory;
@synthesize _delegate;
@synthesize _error;

// Playlist Refresh.
@synthesize _refreshTimer;
@synthesize _oldPlaylist;
@synthesize _oldPlaylistHash;
@synthesize _curPlaylist;
@synthesize _shouldFinishWhenQueueEmpty;
@synthesize _playlistURL;
@synthesize _intervalsSinceLastChange;

// Chunk Download.
@synthesize _downloadQueue;
@synthesize _chunkSequenceNumber;

// Local HLS Generation.
@synthesize _playlistDirectory;
@synthesize _playlistHelper;

#pragma mark Constructors
- (id)initWithPlaylist:(NSURL *)playlist delegate:(id<HLSPlaylistDownloaderDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        
        // Default init.
        _playlistDirectory = nil;
        isConsumed = NO;
        _mediaDirectory = nil;
        _error = NO;
        
        // Path computation.
        _baseURL = [playlist URLByDeletingLastPathComponent];
        _playlistFileName = [playlist lastPathComponent];
        _playlistName = [_playlistFileName stringByDeletingPathExtension];
        
        //        NSLog(@"%@\n%@", _baseURL, _playlistFileName); // DEBUG
    }
    return self;
}

#pragma mark Interface Methods
- (void)downloadToDirectory:(NSString *)directory
{
    if (isConsumed) {
        // Error.
        NSLog(@"this HLSPlaylistDownloader was already used.");
        return;
    }
    
    self.isConsumed = YES;
    _playlistDirectory = directory;
    
    // Setup playlist helper.
    NSString *localPlaylistPath = [_playlistDirectory stringByAppendingPathComponent:_playlistFileName];
    NSURL *localPlaylistURL = [NSURL fileURLWithPath:localPlaylistPath];
    _playlistHelper = [[HLSEventPlaylistHelper alloc] initWithFileURL:localPlaylistURL];
    
    // Set media directory - this is where media files will be stored.
    _mediaDirectory = _playlistDirectory;
    
    [self setupDownloadQueue];
    [self setupPlaylistRefresh];
}

#pragma mark Continuous Playlist Refresh
- (void)setupPlaylistRefresh
{
    _oldPlaylist = [NSString string];
    _curPlaylist = nil;
    _oldPlaylistHash = 0;
    _shouldFinishWhenQueueEmpty = NO;
    _playlistURL = [_baseURL URLByAppendingPathComponent:_playlistFileName];
    _intervalsSinceLastChange = 0;
    
    _refreshTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:kRefreshInterval target:self selector:@selector(refreshTimer_Tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_refreshTimer forMode:NSDefaultRunLoopMode];
    
    if (_delegate) {
        [_delegate playlistDownloader:self didStartDownloadingRemoteStream:_playlistURL];
    }
}

- (void)refreshTimer_Tick:(NSTimer *)timer
{
    //    NSLog(@"tick!"); // DEBUG
    
    // Synchronously get new playlist.
    NSError *downloadError = nil;
    _curPlaylist = [NSString stringWithContentsOfURL:_playlistURL encoding:NSUTF8StringEncoding error:&downloadError];
    if (!_curPlaylist) {
        NSLog(@"PlaylistDownloader/refreshTimer_Tick/download error:%@", downloadError);
        
        // Increment timeout timer.
        _intervalsSinceLastChange++;
    } else {
        // Compare playlists.
        NSUInteger curPlaylistHash = [_curPlaylist hash];
        if (_oldPlaylistHash != curPlaylistHash && ![_oldPlaylist isEqualToString:_curPlaylist]) {
            // Reset timeout timer.
            _intervalsSinceLastChange = 0;
            
            // Discard common portion of playlist (items at the front are guaranteed not to change).
            NSString *diff = [_curPlaylist substringFromIndex:_oldPlaylist.length];
            //            NSLog(@"@start\ndiff:\n%@\n@end\n", diff); // DEBUG
            
            // Parse diff.
            _shouldFinishWhenQueueEmpty = [self parsePartialPlaylist:diff];
            
            // Advance playlist state.
            if (!_shouldFinishWhenQueueEmpty) {
                _oldPlaylistHash = curPlaylistHash;
                _oldPlaylist = _curPlaylist;
            } else {
                [timer invalidate];
            }
        } else {
            NSLog(@"no change in playlist"); // DEBUG
            
            // Increment timeout timer.
            _intervalsSinceLastChange++;
        }
    }
    
    // Check for timeout condition.
    if (_intervalsSinceLastChange >= kStreamTimeoutFactor) {
        // Timeout condition.
        NSLog(@"timeout after:%d", _intervalsSinceLastChange); // DEBUG
        
        if (_delegate) {
            [_delegate playlistDownloader:self didTimeoutWhenDownloadingRemoteStream:_playlistURL];
        }
        
        [self stopOperationWithError];
    }
}

- (BOOL)parsePartialPlaylist:(NSString *)diff
{
    diff = [diff stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL containsEndTag = NO;
    BOOL hasLengthOfNextChunk = NO;
    CGFloat lengthOfNextChunk;
    
    NSArray *lines = [diff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if ([line hasPrefix:kHLSTargetDurationPrefix]) {
            NSString *infString = [line substringFromIndex:kHLSTargetDurationPrefix.length];
            NSUInteger targetDuration = [self targetDurationFromInfString:infString];
            
            [_playlistHelper beginPlaylistWithTargetInterval:targetDuration];
        } else if ([line hasPrefix:kHLSEndListPrefix]) {
            //            NSLog(@"stream ended"); // DEBUG
            
            hasLengthOfNextChunk = NO;
            
            containsEndTag = YES;
        } else if ([line hasPrefix:kHLSChunkPrefix]) {
            NSString *infString = [line substringFromIndex:kHLSChunkPrefix.length];
            
            hasLengthOfNextChunk = YES;
            lengthOfNextChunk = [self chunkDurationFromInfString:infString];
        } else if ([line hasPrefix:kHLSMetaPrefix]) {
            hasLengthOfNextChunk = NO;
            
            // Ignore.
        } else {
            if (!hasLengthOfNextChunk) {
                NSLog(@"invalid playlist");
            }
            
            // Treat as path to chunk.
            NSURL *chunkURL = [_baseURL URLByAppendingPathComponent:line];
            [self addURLToDownloadQueue:chunkURL duration:lengthOfNextChunk];
            
            hasLengthOfNextChunk = NO;
        }
    }
    
    return containsEndTag;
}

// Returns the chunk duration given a string of the form "#EXTINF:12,text"
- (CGFloat)chunkDurationFromInfString:(NSString *)inf
{
    NSArray *tokens = [inf componentsSeparatedByString:@","];
    CGFloat candidate = [[tokens objectAtIndex:0] doubleValue];
    return candidate;
}

- (NSUInteger)targetDurationFromInfString:(NSString *)inf
{
    return (NSUInteger)[inf integerValue];
}

#pragma mark Video Chunk Download
- (void)setupDownloadQueue
{
    _downloadQueue = [[NSOperationQueue alloc] init];
    _downloadQueue.maxConcurrentOperationCount = 1; // Set to 1 to avoid (out of) ordering issues.
    [_downloadQueue addObserver:self forKeyPath:kKVOOperation options:NSKeyValueObservingOptionNew context:nil];
    
    _chunkSequenceNumber = 0;
}

- (void)addURLToDownloadQueue:(NSURL *)url duration:(CGFloat)length
{
    //    NSLog(@"found url:%@", url); // DEBUG
    NSUInteger curSeqNo = _chunkSequenceNumber++;
    NSString *fileName = [NSString stringWithFormat:@"chunk%d.ts", curSeqNo];
    NSString *filePath = [_mediaDirectory stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    HLSChunkDownloadMetaData *meta = [[HLSChunkDownloadMetaData alloc] initWithSequence:curSeqNo URL:fileURL duration:length];
    HLSChunkDownloadOperation *operation = [[HLSChunkDownloadOperation alloc] initWithURL:url outputFile:fileURL meta:meta];
    [operation addObserver:self forKeyPath:kKVOIsFinished options:0 context:nil];
    
    [_downloadQueue addOperation:operation];
}

// Note: We need to observer both individual operations, and the state of the queue itself. We should not try to infer the state
// of the queue from the completion of each chunk download operation, and at the same time, we cannot extract details of a
// download operation from the queue itself.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object class] == [HLSChunkDownloadOperation class] && [keyPath isEqualToString:kKVOIsFinished]) {
        // Executed when a HLS Chunk Download Operation finishes.
        
        HLSChunkDownloadOperation *finishedOp = (HLSChunkDownloadOperation *)object;
        HLSChunkDownloadMetaData *meta = finishedOp.meta;
        
        // Timeout on download error. This implementation does not have the infrastructure to retry a chunk download.
        // To do this, we need to implement a windowed buffer.
        if (finishedOp.error) {
            if (_delegate) {
                [_delegate playlistDownloader:self didTimeoutWhenDownloadingRemoteStream:_playlistURL];
            }
            
            [self stopOperationWithError];
            
            return;
        }
        
        NSString *relativePath = [meta.path lastPathComponent];
        [_playlistHelper appendItem:relativePath withDuration:meta.duration];
        
        if (_delegate) {
            [_delegate playlistDownloader:self didDownloadNewChunkForRemoteStream:_playlistURL];
        }
        
        [finishedOp removeObserver:self forKeyPath:kKVOIsFinished];
    } else if ([object class] == [NSOperationQueue class] && [keyPath isEqualToString:kKVOOperation]) {
        // Executed when the operation queue finishes an operation.
        
        NSArray *queueState = (NSArray *)[change valueForKey:NSKeyValueChangeNewKey];
        if (_shouldFinishWhenQueueEmpty && queueState.count == 0) {
            [_playlistHelper endPlaylist];
            
            if (_delegate) {
                [_delegate playlistDownloader:self didFinishDownloadingRemoteStream:_playlistURL];
            }
        }
    }
}

#pragma mark Utility
- (void)stopOperationWithError
{
    [_downloadQueue cancelAllOperations];
    _error = YES;
    _shouldFinishWhenQueueEmpty = YES;
    [_refreshTimer invalidate];
}

@end
