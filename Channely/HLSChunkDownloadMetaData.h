//
//  ChunkDownloadMetaData.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `HLSChunkDownloadMetaData` is an immutable data structure that encapsulates a sequence number, path, and duration.
 */
@interface HLSChunkDownloadMetaData : NSObject
@property (readonly) NSUInteger sequenceNumber;
@property (readonly) NSURL *path;
@property (readonly) CGFloat duration;

/**
 Creates and initializes a `HLSChunkDownloadMetaData`.
 
 @param seq Sequence Number.
 @param url Chunk URL.
 @param length Duration of chunk.
 
 @return An initialized instance of this object.
 */
- (id)initWithSequence:(NSUInteger)seq URL:(NSURL *)url duration:(CGFloat)length;

@end
