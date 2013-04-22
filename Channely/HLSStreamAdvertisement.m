//
//  HLSStreamAdvertisement.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamAdvertisement.h"

static NSString *const kAdFormat = @"%d,%@";
static NSUInteger const kExpectedDataComponents = 2;
static NSString *const kProtocolFormat = @"http://%@";
static NSString *const kDescFormat = @"[playlist=%@, count=%d]";

@interface HLSStreamAdvertisement ()
//Redefinitions.
@property (readwrite, strong) NSString *playlist;
@property (nonatomic, readwrite) NSUInteger chunkCount;

// Private Constructor
- (id) initWithPlaylist:(NSString *)pl withChunkCount:(NSUInteger)count;

@end

@implementation HLSStreamAdvertisement
// Redefinitions.
@synthesize playlist;
@synthesize chunkCount;

#pragma mark Static Initialization Only
// Overriden default init.
- (id) init {
    return nil;
}

#pragma mark Constructors
- (id) initWithPlaylist:(NSString *)pl withChunkCount:(NSUInteger)count {
    if (self = [super init]) {
        playlist = pl;
        chunkCount = count;
    }
    return self;
}

#pragma mark External Static Methods
+ (HLSStreamAdvertisement *) advertisementFromString:(NSString *)str {
    NSArray *components = [str componentsSeparatedByString:@","];
    
    if (components.count != kExpectedDataComponents) {
        return nil;
    } else {
        NSUInteger count = [[components objectAtIndex:0] integerValue];
        return [[HLSStreamAdvertisement alloc] initWithPlaylist:[components objectAtIndex:1]  withChunkCount:count];
    }
}

+ (NSString *) packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl {
    NSString *result = [NSString stringWithFormat:kAdFormat, count, pl];
    return result;
}

#pragma mark Utility
- (NSString *) description {
    return [NSString stringWithFormat:kDescFormat, playlist, chunkCount];
}

@end
