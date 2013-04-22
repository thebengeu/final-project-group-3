//
//  ChunkDownloadMetaData.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSChunkDownloadMetaData : NSObject
@property (readonly) NSUInteger sequenceNumber;
@property (readonly) NSURL *path;
@property (readonly) CGFloat duration;

- (id)initWithSequence:(NSUInteger)seq URL:(NSURL *)url duration:(CGFloat)length;

@end
