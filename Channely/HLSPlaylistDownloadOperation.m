//
//  HLSPlaylistDownloadOperation.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSPlaylistDownloadOperation.h"

static NSString *const cKVOIsExecuting = @"isExecuting";
static NSString *const cKVOIsFinished = @"isFinished";
static NSString *const cHTMLDebugPageFormat = @"<!DOCTYPE html><html><head><title>Local Stream View</title></head><body><div><video src=\"%@.m3u8\" controls autoplay></video></div></body></html>";
static NSString *const cHTMLDebugPageName = @"view.html";

@interface HLSPlaylistDownloadOperation ()
// Internal.
@property (strong) NSString *_recordingId;
@property (strong) NSURL *_playlistURL;
@property (strong) NSString *_downloadDirectory;
@property (strong) HLSPlaylistDownloader *_worker;
@property (atomic) BOOL _expectingFirstChunk;
@property (atomic) NSUInteger _chunkCount;

// Redefinitions.
@property (atomic, readwrite) BOOL isExecuting;
@property (atomic, readwrite) BOOL isFinished;

@end

@implementation HLSPlaylistDownloadOperation
// Internal.
@synthesize _recordingId;
@synthesize _playlistURL;
@synthesize _downloadDirectory;
@synthesize _worker;
@synthesize _expectingFirstChunk;
@synthesize _chunkCount;

// Redefinitions.
@synthesize isExecuting;
@synthesize isFinished;

#pragma mark Constructors
- (id) initWithStreamId:(NSString *)rId forPlaylist:(NSURL *)playlistURL toDirectory:(NSString *)dir {
    if (self = [super init]) {
        isExecuting = NO;
        isFinished = NO;
        
        _recordingId = rId;
        _playlistURL = playlistURL;
        _downloadDirectory = dir;
        
        _worker = [[HLSPlaylistDownloader alloc] initWithPlaylist:_playlistURL delegate:self];
    }
    return self;
}

#pragma mark Logic
- (BOOL) isConcurrent {
    return YES;
}

- (void) start {
    if (![NSThread isMainThread]) {
        NSLog(@"moving download operation to main thread."); // DEBUG
        
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSLog(@"download operation started."); // DEBUG
    
    _expectingFirstChunk = YES;
    _chunkCount = 0;
    
    [_worker downloadToDirectory:_downloadDirectory];
    
    [self willChangeValueForKey:cKVOIsExecuting];
    isExecuting = YES;
    [self didChangeValueForKey:cKVOIsExecuting];
}

- (void) finish {
    [self willChangeValueForKey:cKVOIsExecuting];
    [self willChangeValueForKey:cKVOIsFinished];
    
    isExecuting = NO;
    isFinished = YES;
    
    [self didChangeValueForKey:cKVOIsExecuting];
    [self didChangeValueForKey:cKVOIsFinished];
}

#pragma mark Playlist Downloader Delegate
- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didDownloadNewChunkForRemoteStream:(NSURL *)stream {
    _chunkCount++;
    
    // We guarantee that the relative path will never contain a comma ',' -
    // otherwise this will violate the precondition of HLSStreamDiscoveryManager.
    NSString *localPlaylistRelativePath = [_recordingId stringByAppendingPathComponent:[_playlistURL lastPathComponent]];
    [[HLSStreamAdvertisingManager discoveryManager] updateAdvertisementForPlaylist:localPlaylistRelativePath asRecordingId:_recordingId withChunkCount:_chunkCount];
    
    // DEBUG - create a Safari-viewable HTML page that can be used to display the local stream.
    if (_expectingFirstChunk) {
        NSLog(@"sync: first chunk downloaded");
        
        NSString *pageContent = [NSString stringWithFormat:cHTMLDebugPageFormat, _recordingId];
        NSString *pagePath = [_downloadDirectory stringByAppendingPathComponent:cHTMLDebugPageName];
        [pageContent writeToFile:pagePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        _expectingFirstChunk = NO;
    }
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream {
    NSLog(@"sync complete"); // DEBUG
    
    [self finish];
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream {
    // Ignore.
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream {
    // Ignore.
}

@end
