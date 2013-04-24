//
//  HLSPlaylistDownloadOperation.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSPlaylistDownloadOperation.h"

@interface HLSPlaylistDownloadOperation ()
// Internal.
@property (strong) NSURL *_playlistURL;
@property (strong) NSString *_downloadDirectory;
@property (strong) HLSPlaylistDownloader *_worker;
@property (atomic) BOOL _expectingFirstChunk;
@property (atomic) NSUInteger _chunkCount;

// Redefinitions.
@property (atomic, readwrite) BOOL isExecuting;
@property (atomic, readwrite) BOOL isFinished;
@property (readwrite, weak) id<HLSPlaylistDownloadOperationDelegate> delegate;

@end

@implementation HLSPlaylistDownloadOperation
// Internal.
@synthesize recordingId;
@synthesize _playlistURL;
@synthesize _downloadDirectory;
@synthesize _worker;
@synthesize _expectingFirstChunk;
@synthesize _chunkCount;

// Redefinitions.
@synthesize isExecuting;
@synthesize isFinished;
@synthesize delegate;

#pragma mark Constructors
- (id)initWithStreamId:(NSString *)rId forPlaylist:(NSURL *)playlistURL toDirectory:(NSString *)dir delegate:(id<HLSPlaylistDownloadOperationDelegate>)del
{
    if (self = [super init]) {
        isExecuting = NO;
        isFinished = NO;
        
        recordingId = rId;
        _playlistURL = playlistURL;
        _downloadDirectory = dir;
        delegate = del;
        
        _worker = [[HLSPlaylistDownloader alloc] initWithPlaylist:_playlistURL delegate:self];
    }
    return self;
}

#pragma mark Logic
- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if (![NSThread isMainThread]) {
        NSLog(@"moving download operation to main thread."); // DEBUG
        
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSLog(@"download operation started."); // DEBUG
    
    _expectingFirstChunk = YES;
    _chunkCount = 0;
    
    [_worker downloadToDirectory:_downloadDirectory];
    
    [self willChangeValueForKey:kKVOIsExecuting];
    isExecuting = YES;
    [self didChangeValueForKey:kKVOIsExecuting];
    if (delegate) {
        [delegate playlistDownloadOperationDidStart:self];
    }
}

- (void)finish
{
    [self willChangeValueForKey:kKVOIsExecuting];
    [self willChangeValueForKey:kKVOIsFinished];
    
    isExecuting = NO;
    isFinished = YES;
    
    [self didChangeValueForKey:kKVOIsExecuting];
    [self didChangeValueForKey:kKVOIsFinished];
    
    if (delegate) {
        [delegate playlistDownloadOperationDidFinish:self];
    }
}

#pragma mark Playlist Downloader Delegate
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didDownloadNewChunkForRemoteStream:(NSURL *)stream
{
    _chunkCount++;
    
    // We guarantee that the relative path will never contain a comma ',' -
    // otherwise this will violate the precondition of HLSStreamDiscoveryManager.
    NSString *localPlaylistRelativePath = [recordingId stringByAppendingPathComponent:[_playlistURL lastPathComponent]];
    [[HLSStreamAdvertisingManager advertisingManager] updateAdvertisementForPlaylist:localPlaylistRelativePath asRecordingId:recordingId withChunkCount:_chunkCount];
    
    // DEBUG - create a Safari-viewable HTML page that can be used to display the local stream.
    if (_expectingFirstChunk) {
        NSLog(@"sync: first chunk downloaded");
        
        NSString *pageContent = [NSString stringWithFormat:kDebugPageMarkup, recordingId];
        NSString *pagePath = [_downloadDirectory stringByAppendingPathComponent:kDebugPageName];
        [pageContent writeToFile:pagePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        _expectingFirstChunk = NO;
    }
}

- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream
{
    NSLog(@"sync complete"); // DEBUG
    
    // Set bit-flag in chunkCount to indicate that a stream is complete.
    _chunkCount = (_chunkCount | (1 << kCompleteStreamShift));
    NSString *localPlaylistRelativePath = [recordingId stringByAppendingPathComponent:[_playlistURL lastPathComponent]];
    [[HLSStreamAdvertisingManager advertisingManager] updateAdvertisementForPlaylist:localPlaylistRelativePath asRecordingId:recordingId withChunkCount:_chunkCount];
    
    [self finish];
}

- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream
{
    // Ignore.
}

// The timeout condition is triggered when some error occured during a playlist download. The resultant stream
// is not guaranteed to be playable, and the software must stop advertising the stream over P2P.
// We also clear the downloaded files to save space.
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream
{
    NSLog(@"download operation timed out."); // DEBUG
    
    // Stop advertising.
    HLSStreamAdvertisingManager *am = [HLSStreamAdvertisingManager advertisingManager];
    if ([am isAdvertisingRecordingId:recordingId]) {
        [am stopAdvertisingRecordingId:recordingId];
    }
    
    // Clear folder.
    [ChanUtility removeItemAtPath:_downloadDirectory];
    
    [self finish];
}

@end
