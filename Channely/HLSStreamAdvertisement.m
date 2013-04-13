//
//  HLSStreamAdvertisement.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamAdvertisement.h"

static NSString *const cAdFormat = @"%d,%@";
static NSUInteger const cExpectedDataComponents = 2;
static NSString *const cProtocolFormat = @"http://%@";
static NSString *const cDescFormat = @"[ip=%@, playlist=%@, count=%d]";

@interface HLSStreamAdvertisement ()
//Redefinitions.
@property (readwrite, strong) NSString *hostDD4;
@property (readwrite, strong) NSString *playlist;
@property (nonatomic, readwrite) NSUInteger chunkCount;
@property (readwrite, strong) NSString *recordingId;

// Private Constructor
- (id) initWithPlaylist:(NSString *)pl onHost:(NSString *)dd4 withChunkCount:(NSUInteger)count;

@end

@implementation HLSStreamAdvertisement
// Redefinitions.
@synthesize hostDD4;
@synthesize playlist;
@synthesize chunkCount;
@synthesize recordingId;

#pragma mark Static Initialization Only
// Overriden default init.
- (id) init {
    return nil;
}

#pragma mark Constructors
- (id) initWithPlaylist:(NSString *)pl onHost:(NSString *)dd4 forRecording:(NSString *)rId withChunkCount:(NSUInteger)count {
    if (self = [super init]) {
        playlist = pl;
        chunkCount = count;
        hostDD4 = dd4;
        recordingId = rId;
    }
    return self;
}

#pragma mark External Static Methods
+ (HLSStreamAdvertisement *) advertisementFromData:(NSData *)data onHost:(NSString *)dd4 withRecordingId:(NSString *)rId {
    NSString *representativeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [representativeString componentsSeparatedByString:@","];
    
    if (components.count != cExpectedDataComponents) {
        return nil;
    } else {
        NSUInteger count = [[components objectAtIndex:0] integerValue];
        return [[HLSStreamAdvertisement alloc] initWithPlaylist:[components objectAtIndex:1] onHost:dd4 forRecording:rId withChunkCount:count];
    }
}

+ (NSString *) packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl {
    NSString *result = [NSString stringWithFormat:cAdFormat, count, pl];
    return result;
}

#pragma mark Utility
- (NSString *) description {
    return [NSString stringWithFormat:cDescFormat, hostDD4, playlist, chunkCount];
}

@end
