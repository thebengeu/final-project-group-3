//
//  HLSStreamSync.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamSync.h"

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
    // TODO
}

@end
