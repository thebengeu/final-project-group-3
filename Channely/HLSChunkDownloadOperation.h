//
//  URLDownloadOperation.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSChunkDownloadMetaData.h"

@interface HLSChunkDownloadOperation : NSOperation
@property (readonly, strong) HLSChunkDownloadMetaData *meta;
@property (atomic, readonly) BOOL error;

- (id)initWithURL:(NSURL *)source outputFile:(NSURL *)target meta:(HLSChunkDownloadMetaData *)data;

@end
