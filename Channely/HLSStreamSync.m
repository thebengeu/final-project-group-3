//
//  HLSStreamSync.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamSync.h"

static NSString *const cPlaylistFilenameFormat = @"%@.m3u8";
static NSUInteger const cCompleteStreamShift = 31;

@interface HLSStreamSync ()
// Internal.
@property (strong) NSString *_baseDirectory;
@property (strong) NSOperationQueue *_opQueue;
@property (strong) NSMutableArray *_runningOps;
@property (strong) NSMutableArray *_waitingOps;

- (id) initWithBaseDirectory:(NSString *)dir;
- (BOOL) recordingIdInWaitQueue:(NSString *)rId;
- (BOOL) recordingIdIsRunning:(NSString *)rId;

@end

@implementation HLSStreamSync
static HLSStreamSync *_internal;

@synthesize _baseDirectory;
@synthesize _opQueue;
@synthesize _runningOps;
@synthesize _waitingOps;

#pragma mark Singleton
- (id) init {
    return nil;
}

+ (HLSStreamSync *) streamSync {
    return _internal;
}

+ (HLSStreamSync *) setupStreamSyncWithBaseDirectory:(NSString *)dir {
    if (!_internal) {
        _internal = [[HLSStreamSync alloc] initWithBaseDirectory:dir];
        return _internal;
    } else {
        return nil;
    }
}

#pragma mark Constructors
- (id) initWithBaseDirectory:(NSString *)dir {
    if (self = [super init]) {
        _baseDirectory = dir;
        _opQueue = [[NSOperationQueue alloc] init];
        _runningOps = [NSMutableArray array];
        _waitingOps = [NSMutableArray array];
    }
    return self;
}

#pragma mark External Logic
- (NSUInteger) operationCount {
    return _opQueue.operationCount;
}

- (void) syncStreamId:(NSString *)sId playlistURL:(NSURL *)playlist {
    NSString *streamDir = [_baseDirectory stringByAppendingPathComponent:sId];
    
    if ([ChanUtility directoryExists:streamDir]) {
        if ([self completeLocalStreamExistsForStreamId:sId]) {
            NSLog(@"complete stream exists. not redownloading."); // DEBUG.
            return;
        } else if ([self recordingIdInWaitQueue:sId] || [self recordingIdIsRunning:sId]) {
            NSLog(@"stream is currently downloading or in download queue. not redownloading."); // DEBUG.
            return;
        } else {
            NSLog(@"incomplete stream. pruning and redownloading."); // DEBUG.
            [ChanUtility removeItemAtPath:streamDir];
        }
    }
    
    // Non-destructive.
    [ChanUtility createDirectory:streamDir];
    
    HLSPlaylistDownloadOperation *operation = [[HLSPlaylistDownloadOperation alloc] initWithStreamId:sId forPlaylist:playlist toDirectory:streamDir delegate:self];
    [_opQueue addOperation:operation];
    [_waitingOps addObject:operation];
}

- (BOOL) completeLocalStreamExistsForStreamId:(NSString *)sId {
    NSString *streamDir = [_baseDirectory stringByAppendingPathComponent:sId];
    NSString *playlistPath = [streamDir stringByAppendingPathComponent:[NSString stringWithFormat:cPlaylistFilenameFormat, sId]];
    return ([ChanUtility directoryExists:streamDir] && [HLSEventPlaylistHelper playlistIsComplete:playlistPath]);
}

- (void) recheckExistingStreams {
    NSLog(@"rechecking existing streams and performing prune of partial streams."); // DEBUG.
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *items = [fm contentsOfDirectoryAtPath:_baseDirectory error:nil];
    for (NSString *itemPath in items) {
        NSString *fullItemPath = [_baseDirectory stringByAppendingPathComponent:itemPath];
        
        NSLog(@"Checking item:%@", fullItemPath); // DEBUG.
        
        BOOL isDir = NO;
        [fm fileExistsAtPath:fullItemPath isDirectory:&isDir];
        
        if (!isDir) {
            NSLog(@"not a directory:%@. removing.", fullItemPath); // DEBUG.
            
            [fm removeItemAtPath:fullItemPath error:nil];
            continue;
        }
        
        NSString *sId = itemPath;
        HLSStreamAdvertisingManager *am = [HLSStreamAdvertisingManager advertisingManager];
        if ([self completeLocalStreamExistsForStreamId:sId]) {
            NSLog(@"found existing complete stream: %@. re-advertising.", sId); // DEBUG.
            
            NSString *playlistRelativePath = [sId stringByAppendingPathComponent:[NSString stringWithFormat:cPlaylistFilenameFormat, sId]];
            NSUInteger chunkCount = [HLSEventPlaylistHelper playlistChunkCount:playlistRelativePath];
            NSUInteger countField = (1 << cCompleteStreamShift) | chunkCount;
            
            [am updateAdvertisementForPlaylist:playlistRelativePath asRecordingId:sId withChunkCount:countField];
        } else {
            NSLog(@"removing incomplete stream."); // DEBUG.
            
            if ([am isAdvertisingRecordingId:sId]) {
                [am stopAdvertisingRecordingId:sId];
            }
            [fm removeItemAtPath:fullItemPath error:nil];
        }
    }
}

#pragma mark Logic
- (BOOL) recordingIdInWaitQueue:(NSString *)rId {
    for (HLSPlaylistDownloadOperation *op in _waitingOps) {
        if ([op.recordingId isEqualToString:rId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) recordingIdIsRunning:(NSString *)rId {
    for (HLSPlaylistDownloadOperation *op in _runningOps) {
        if ([op.recordingId isEqualToString:rId]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark HLS Playlist Download Operation Delegate
- (void) playlistDownloadOperationDidFinish:(HLSPlaylistDownloadOperation *)operation {
    [_runningOps removeObject:operation];
}

- (void) playlistDownloadOperationDidStart:(HLSPlaylistDownloadOperation *)operation {
    [_waitingOps removeObject:operation];
    [_runningOps addObject:operation];
}

@end
