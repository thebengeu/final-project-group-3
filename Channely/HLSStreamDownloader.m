//
//  HLSDownloader.m
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamDownloader.h"

NSTimeInterval const cRefreshInterval = 5.0; // Time in seconds.
NSUInteger const cStreamTimeoutFactor = 5; // No. intervals before concluding timeout.
NSString *const cHLSTargetDurationPrefix = @"#EXT-X-TARGETDURATION:";
NSString *const cHLSEndListPrefix = @"#EXT-X-ENDLIST";
NSString *const cHLSChunkPrefix = @"#EXTINF:";
NSString *const cHLSMetaPrefix = @"#";
NSString *const cKVOIsFinished = @"isFinished";
NSString *const cKVOOperation = @"operations";
NSString *const cMediaDirectoryFormat = @"%@";
NSString *const cRelativePathFormat = @"%@/%@";

@interface HLSStreamDownloader ()
// Redefinitions.
@property (atomic, readwrite) BOOL isConsumed;

// Internal.
@property (strong) NSURL *_baseURL;
@property (strong) NSString *_playlistFileName;
@property (strong) NSString *_playlistName;
@property (strong) NSString *_mediaDirectory;

// Playlist Refresh.
@property (strong) NSTimer *_refreshTimer;
@property (strong) NSString *_oldPlaylist;
@property (atomic) NSUInteger _oldPlaylistHash;
@property (strong) NSString *_curPlaylist;
@property (atomic) BOOL _shouldFinishWhenQueueEmpty;
@property (strong) NSURL *_playlistURL;
@property (atomic) NSUInteger _intervalsSinceLastChange;
- (void) setupPlaylistRefresh;
- (void) refreshTimer_Tick:(NSTimer *)timer;
- (BOOL) parsePartialPlaylist:(NSString *)diff;
- (CGFloat) chunkDurationFromInfString:(NSString *)inf;
- (CGFloat) targetDurationFromInfString:(NSString *)inf;

// Chunk Download.
@property (strong) NSOperationQueue *_downloadQueue;
@property (atomic) NSUInteger _chunkSequenceNumber;
- (void) setupDownloadQueue;
- (void) addURLToDownloadQueue:(NSURL *)url duration:(CGFloat)length;
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

// Local HLS Generation.
@property (strong) NSString *_playlistDirectory;
@property (strong) HLSEventPlaylistHelper *_playlistHelper;

@end

@implementation HLSStreamDownloader
// Redefinitions.
@synthesize isConsumed;

// Internal.
@synthesize _baseURL;
@synthesize _playlistFileName;
@synthesize _playlistName;
@synthesize _mediaDirectory;

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
- (id) initWithPlaylist:(NSURL *)playlist {
    if (self = [super init]) {
        // Default init.
        _playlistDirectory = nil;
        isConsumed = NO;
        _mediaDirectory = nil;
        
        // Path computation.
        _baseURL = [playlist URLByDeletingLastPathComponent];
        _playlistFileName = [playlist lastPathComponent];
        _playlistName = [_playlistFileName stringByDeletingPathExtension];
        
        NSLog(@"%@\n%@", _baseURL, _playlistFileName); // DEBUG
    }
    return self;
}

#pragma mark Interface Methods
- (void) downloadToDirectory:(NSString *)directory {
    if (isConsumed) {
        // Error.
        NSLog(@"this HLSDownloader was already used.");
        return;
    }
    
    self.isConsumed = YES;
    _playlistDirectory = directory;
    
    // Setup playlist helper.
    NSString *localPlaylistPath = [_playlistDirectory stringByAppendingPathComponent:_playlistFileName];
    NSURL *localPlaylistURL = [NSURL fileURLWithPath:localPlaylistPath];
    _playlistHelper = [[HLSEventPlaylistHelper alloc] initWithFileURL:localPlaylistURL];
    
    // Create media content directory.
    NSFileManager *fm = [NSFileManager defaultManager];
    _mediaDirectory = [_playlistDirectory stringByAppendingPathComponent:_playlistName];
    NSLog(@"mediaDirectory=%@", _mediaDirectory); // DEBUG
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:_mediaDirectory isDirectory:&isDirectory] && isDirectory) {
        [fm removeItemAtPath:_mediaDirectory error:nil];
    }
    [fm createDirectoryAtPath:_mediaDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    
    [self setupDownloadQueue];
    [self setupPlaylistRefresh];
}

#pragma mark Continuous Playlist Refresh
- (void) setupPlaylistRefresh {
    _oldPlaylist = [NSString string];
    _curPlaylist = nil;
    _oldPlaylistHash = 0;
    _shouldFinishWhenQueueEmpty = NO;
    _playlistURL = [_baseURL URLByAppendingPathComponent:_playlistFileName];
    _intervalsSinceLastChange = 0;
    
    _refreshTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:cRefreshInterval target:self selector:@selector(refreshTimer_Tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_refreshTimer forMode:NSDefaultRunLoopMode];
}

- (void) refreshTimer_Tick:(NSTimer *)timer {
    NSLog(@"tick!"); // DEBUG
    
    // Synchronously get new playlist.
    NSError *downloadError = nil;
    _curPlaylist = [NSString stringWithContentsOfURL:_playlistURL encoding:NSUTF8StringEncoding error:&downloadError];
    if (downloadError) {
        NSLog(@"download error");
        
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
            NSLog(@"@start\ndiff:\n%@\n@end\n", diff); // DEBUG
            
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
    if (_intervalsSinceLastChange >= cStreamTimeoutFactor) {
        // Timeout condition.
        NSLog(@"timeout after:%d", _intervalsSinceLastChange); // DEBUG
        
        _shouldFinishWhenQueueEmpty = YES;
        [timer invalidate];
    }
}

- (BOOL) parsePartialPlaylist:(NSString *)diff {
    diff = [diff stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL containsEndTag = NO;
    BOOL hasLengthOfNextChunk = NO;
    CGFloat lengthOfNextChunk;
    
    NSArray *lines = [diff componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if ([line hasPrefix:cHLSTargetDurationPrefix]) {
            NSString *infString = [line substringFromIndex:cHLSTargetDurationPrefix.length];
            CGFloat targetDuration = [self targetDurationFromInfString:infString];
            
            [_playlistHelper beginPlaylistWithTargetInterval:targetDuration];
        } else if ([line hasPrefix:cHLSEndListPrefix]) {
            NSLog(@"stream ended"); // DEBUG
            
            hasLengthOfNextChunk = NO;
            
            containsEndTag = YES;
        } else if ([line hasPrefix:cHLSChunkPrefix]) {
            NSString *infString = [line substringFromIndex:cHLSChunkPrefix.length];

            hasLengthOfNextChunk = YES;
            lengthOfNextChunk = [self chunkDurationFromInfString:infString];
        } else if ([line hasPrefix:cHLSMetaPrefix]) {
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

- (CGFloat) chunkDurationFromInfString:(NSString *)inf {
    NSArray *tokens = [inf componentsSeparatedByString:@","];
    CGFloat candidate = [[tokens objectAtIndex:0] doubleValue];
    return candidate;
}

- (CGFloat) targetDurationFromInfString:(NSString *)inf {
    return [inf doubleValue];
}

#pragma mark Video Chunk Download
- (void) setupDownloadQueue {
    _downloadQueue = [[NSOperationQueue alloc] init];
    _downloadQueue.maxConcurrentOperationCount = 1; // Set to 1 to avoid (out of) ordering issues.
    [_downloadQueue addObserver:self forKeyPath:cKVOOperation options:NSKeyValueObservingOptionNew context:nil];
    
    _chunkSequenceNumber = 0;
}

- (void) addURLToDownloadQueue:(NSURL *)url duration:(CGFloat)length {
    NSLog(@"found url:%@", url); // DEBUG
    
    NSUInteger curSeqNo = _chunkSequenceNumber++;
    NSString *fileName = [NSString stringWithFormat:@"chunk%d.ts", curSeqNo];
    NSString *filePath = [_mediaDirectory stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    HLSChunkDownloadMetaData *meta = [[HLSChunkDownloadMetaData alloc] initWithSequence:curSeqNo URL:fileURL duration:length]; // PLACEHOLDER
    HLSChunkDownloadOperation *operation = [[HLSChunkDownloadOperation alloc] initWithURL:url outputFile:fileURL meta:meta];
    [operation addObserver:self forKeyPath:cKVOIsFinished options:0 context:nil];
    
    [_downloadQueue addOperation:operation];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object class] == [HLSChunkDownloadOperation class] && [keyPath isEqualToString:cKVOIsFinished]) {
        HLSChunkDownloadOperation *finishedOp = (HLSChunkDownloadOperation *)object;
        HLSChunkDownloadMetaData *meta = finishedOp.meta;
        
        NSLog(@"chunk seq:%d duration:%lf downloaded to file:%@", meta.sequenceNumber, meta.duration, meta.path); // DEBUG
        
        NSString *relativePath = [NSString stringWithFormat:cRelativePathFormat, _playlistName, [meta.path lastPathComponent]];
        [_playlistHelper appendItem:relativePath withDuration:meta.duration];
        
        [finishedOp removeObserver:self forKeyPath:cKVOIsFinished];
    } else if ([object class] == [NSOperationQueue class] && [keyPath isEqualToString:cKVOOperation]) {
        NSArray *queueState = (NSArray *)[change valueForKey:NSKeyValueChangeNewKey];
        if (_shouldFinishWhenQueueEmpty && queueState.count == 0) {
            [_playlistHelper endPlaylist];
        }
    }
}

@end