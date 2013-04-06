//
//  HLSStreamDownloaderDelegate.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLSStreamDownloader;

@protocol HLSStreamDownloaderDelegate <NSObject>
// Informational.
- (void) streamDownloader:(HLSStreamDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream;
- (void) streamDownloader:(HLSStreamDownloader *)dl didDownloadNewChunkForRemoteStream:(NSURL *)stream;
- (void) streamDownloader:(HLSStreamDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream;

// Error.
- (void) streamDownloader:(HLSStreamDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream;

@end
