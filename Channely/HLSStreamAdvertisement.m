//
//  HLSStreamAdvertisement.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamAdvertisement.h"

static NSString *const cAdFormat = @"%d,%@";

@interface HLSStreamAdvertisement ()
//Redefinitions.
@property (readwrite, strong) NSString *playlist;
@property (nonatomic, readwrite) NSUInteger chunkCount;

// Private Constructor
- (id) initWithPlaylist:(NSString *)pl chunkCount:(NSUInteger)count;

@end

@implementation HLSStreamAdvertisement
// Redefinitions.
@synthesize playlist;
@synthesize chunkCount;

#pragma mark Constructors
- (id) initWithPlaylist:(NSString *)pl chunkCount:(NSUInteger)count {
    if (self = [super init]) {
        playlist = pl;
        chunkCount = count;
    }
    return self;
}

#pragma mark External Static Methods
+ (HLSStreamAdvertisement *) streamAdvertisementFromData:(NSData *)data {
    // TODO
    return [[HLSStreamAdvertisement alloc] initWithPlaylist:@"" chunkCount:0];
}

+ (NSString *) packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl {
    NSString *result = [NSString stringWithFormat:cAdFormat, count, pl];
    return result;
}

@end
