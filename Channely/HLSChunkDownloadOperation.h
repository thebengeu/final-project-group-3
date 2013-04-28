//
//  URLDownloadOperation.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSChunkDownloadMetaData.h"

/**
 This operation downloads a file at a remote location pointed to by a URL. A client class can query the status of the download by inspecting the `error` parameter.
 */
@interface HLSChunkDownloadOperation : NSOperation
@property (readonly, strong) HLSChunkDownloadMetaData *meta;
@property (atomic, readonly) BOOL error;

/**
 Creates and initializes a `HLSChunkDownloadOperation`.
 
 @param source The URL of the file to download.
 @param target The destination to write downloaded data.
 @param data Metadata associated with this operation.
 
 @return An initialized instance of this operation.
 */
- (id)initWithURL:(NSURL *)source outputFile:(NSURL *)target meta:(HLSChunkDownloadMetaData *)data;

@end
