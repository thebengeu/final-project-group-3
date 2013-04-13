//
//  HLSNetServiceURLChunkCountTuple.m
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSNetServicePathChunkCountTuple.h"

@interface HLSNetServicePathChunkCountTuple ()
@property (readwrite, strong) NSNetService *netService;
@property (readwrite, strong) NSString *relativePath;
@property (readwrite, atomic) NSUInteger chunkCount;

@end

@implementation HLSNetServicePathChunkCountTuple
@synthesize netService;
@synthesize relativePath;
@synthesize chunkCount;

- (id) initWithNetService:(NSNetService *)ns path:(NSString *)path count:(NSUInteger)count {
    if (self = [super init]) {
        netService = ns;
        relativePath = path;
        chunkCount = count;
    }
    return self;
}

@end
