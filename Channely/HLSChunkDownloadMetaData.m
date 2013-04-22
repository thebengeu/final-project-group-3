//
//  ChunkDownloadMetaData.m
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSChunkDownloadMetaData.h"

@interface HLSChunkDownloadMetaData ()
@property (readwrite) NSUInteger sequenceNumber;
@property (readwrite) NSURL *path;
@property (readwrite) CGFloat duration;

@end

@implementation HLSChunkDownloadMetaData
@synthesize sequenceNumber;
@synthesize path;
@synthesize duration;

- (id)initWithSequence:(NSUInteger)seq URL:(NSURL *)url duration:(CGFloat)length
{
    if (self = [super init]) {
        sequenceNumber = seq;
        path = url;
        duration = length;
    }
    return self;
}

@end
