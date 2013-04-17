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

- (id) initWithBaseDirectory:(NSString *)dir;

@end

@implementation HLSStreamSync
static HLSStreamSync *_internal;

@synthesize _baseDirectory;
@synthesize _opQueue;

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
        
    }
    return self;
}

#pragma mark External Logic
- (NSUInteger) operationCount {
    return _opQueue.operationCount;
}

- (void) syncStreamId:(NSString *)sId playlistURL:(NSURL *)playlist {
    NSString *streamDir = [_baseDirectory stringByAppendingPathComponent:sId];
//    NSString *playlistPath = [streamDir stringByAppendingPathComponent:[playlist lastPathComponent]];
    
    if ([ChanUtility directoryExists:streamDir]) {
        NSLog(@"files for local stream exists, not syncing.");
        return;
    }
    
    [ChanUtility createDirectory:streamDir];
    
    HLSPlaylistDownloadOperation *operation = [[HLSPlaylistDownloadOperation alloc] initWithStreamId:sId forPlaylist:playlist toDirectory:streamDir];
    [_opQueue addOperation:operation];
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

@end
