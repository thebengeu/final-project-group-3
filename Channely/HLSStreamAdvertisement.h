//
//  HLSStreamAdvertisement.h
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `HLSStreamAdvertisement` is an immutable data structure that encapsulates a playlist and its corresponding chunk count.
 */
@interface HLSStreamAdvertisement : NSObject
@property (readonly, strong) NSString *playlist;
@property (nonatomic, readonly) NSUInteger chunkCount;

/**
 `HLSStreamAdvertisement` can only be created by its factory. This method returns `nil`.
 
 @return `nil`.
 */
- (id)init;

- (NSString *)description;

/**
 Parses a string and returns a `HLSStreamAdvertisement`.
 
 @param str The string to parse.
 
 @return The `HLSStreamAdvertisement` that was parsed. If the parse fails, returns `nil`.
 */
+ (HLSStreamAdvertisement *)advertisementFromString:(NSString *)str;

/**
 Creates a serialized string representing a `HLSStreamAdvertisement`.
 
 @param count The chunk count to represent.
 @param pl The playlist to represent.
 
 @return The serialized advertisement as an `NSString`.
 */
+ (NSString *)packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl;

@end
