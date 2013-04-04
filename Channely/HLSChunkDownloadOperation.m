//
//  URLDownloadOperation.m
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSChunkDownloadOperation.h"

@interface HLSChunkDownloadOperation ()
// Internal.
@property (strong) NSURL *_source;
@property (strong) NSURL *_target;
@property (readwrite, strong) HLSChunkDownloadMetaData *meta;

@end

@implementation HLSChunkDownloadOperation
// Internal.
@synthesize _source;
@synthesize _target;
@synthesize meta;

#pragma mark Constructors
- (id) initWithURL:(NSURL *)source outputFile:(NSURL *)target meta:(HLSChunkDownloadMetaData *)data {
    if (self = [super init]) {
        _source = source;
        _target = target;
        meta = data;
    }
    return self;
}

#pragma mark Logic
- (void) main {
    NSData *downloadedData = [NSData dataWithContentsOfURL:_source];
    [downloadedData writeToURL:_target atomically:YES];
}

@end
