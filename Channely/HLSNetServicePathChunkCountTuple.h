//
//  HLSNetServiceURLChunkCountTuple.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `HLSNetServicePathChunkCountTuple` is an immutable data structure that encapsulates an `NSNetService`, a path, and a chunk count.
 */
@interface HLSNetServicePathChunkCountTuple : NSObject
@property (readonly, strong) NSNetService *netService;
@property (readonly, strong) NSString *relativePath;
@property (readonly, atomic) NSUInteger chunkCount;

/**
 Creates and initializes a `HLSChunkDownloadMetaData`.
 
 @param ns The `NSNetService`.
 @param path The path.
 @param count The chunk count.
 
 @return An initialized instance of this object.
 */
- (id)initWithNetService:(NSNetService *)ns path:(NSString *)path count:(NSUInteger)count;

- (NSString *)description;

@end
