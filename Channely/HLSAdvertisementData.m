//
//  HLSStreamAdvertisement.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSAdvertisementData.h"

static NSString *const cAdFormat = @"%d,%@";
static NSUInteger const cExpectedDataComponents = 2;
static NSString *const cProtocolFormat = @"http://%@";

@interface HLSAdvertisementData ()
//Redefinitions.
@property (readwrite, strong) NSString *hostDD4;
@property (readwrite, strong) NSString *playlist;
@property (nonatomic, readwrite) NSUInteger chunkCount;
@property (readwrite, strong) NSDate *created;

// Private Constructor
- (id) initWithPlaylist:(NSString *)pl onHost:(NSString *)dd4 withChunkCount:(NSUInteger)count;

@end

@implementation HLSAdvertisementData
// Redefinitions.
@synthesize hostDD4;
@synthesize playlist;
@synthesize chunkCount;
@synthesize created;

#pragma mark Static Initialization Only
// Overriden default init.
- (id) init {
    return nil;
}

#pragma mark Constructors
- (id) initWithPlaylist:(NSString *)pl onHost:(NSString *)dd4 withChunkCount:(NSUInteger)count {
    if (self = [super init]) {
        playlist = pl;
        chunkCount = count;
        created = [NSDate date];
        hostDD4 = dd4;
    }
    return self;
}

#pragma mark External Static Methods
+ (HLSAdvertisementData *) streamAdvertisementFromData:(NSData *)data forPeerWithAddress:(NSString *)dd4 {
    NSString *representativeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [representativeString componentsSeparatedByString:@","];
    
    if (components.count != cExpectedDataComponents) {
        return nil;
    } else {
        NSUInteger count = [[components objectAtIndex:0] integerValue];
        return [[HLSAdvertisementData alloc] initWithPlaylist:[components objectAtIndex:1] onHost:dd4 withChunkCount:count];
    }
}

+ (NSString *) packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl {
    NSString *result = [NSString stringWithFormat:cAdFormat, count, pl];
    return result;
}

@end
