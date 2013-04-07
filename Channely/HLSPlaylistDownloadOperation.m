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

@interface HLSPlaylistDownloadOperation ()
// Internal.
@property (strong) NSString *_recordingId;
@property (strong) NSURL *_playlistURL;
@property (strong) NSString *_downloadDirectory;
@property (strong) HLSPlaylistDownloader *_worker;
@property (atomic) BOOL _expectingFirstChunk;

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
    _expectingFirstChunk = YES;
    
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
    if (_expectingFirstChunk) {
        NSString *playlistName = [_playlistURL lastPathComponent];
        [[HLSStreamDiscoveryManager discoveryManager] startAdvertisingPlaylist:playlistName asRecordingId:_recordingId];
    }
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream {
    [self finish];
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream {
    // Ignore.
}

- (void) playlistDownloader:(HLSPlaylistDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream {
    // Ignore.
}

@end
