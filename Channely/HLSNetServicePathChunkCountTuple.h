//
//  HLSNetServiceURLChunkCountTuple.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents an immutable tuple of the following:
@interface HLSNetServicePathChunkCountTuple : NSObject
@property (readonly, strong) NSNetService *netService;
@property (readonly, strong) NSString *relativePath;
@property (readonly, atomic) NSUInteger chunkCount;

- (id) initWithNetService:(NSNetService *)ns path:(NSString *)path count:(NSUInteger)count;

@end
