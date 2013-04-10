//
//  HLSStreamAdvertisement.h
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSStreamAdvertisement : NSObject
@property (readonly, strong) NSString *playlist;
@property (nonatomic, readonly) NSUInteger chunkCount;

+ (HLSStreamAdvertisement *) streamAdvertisementFromData:(NSData *)data;
+ (NSString *) packAdvertisementForChunkCount:(NSUInteger)count playlist:(NSString *)pl;

@end
