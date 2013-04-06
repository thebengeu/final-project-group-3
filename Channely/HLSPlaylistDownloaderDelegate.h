//
//  HLSStreamDownloaderDelegate.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLSPlaylistDownloader;

@protocol HLSPlaylistDownloaderDelegate <NSObject>
// Informational.
- (void) streamDownloader:(HLSPlaylistDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream;
- (void) streamDownloader:(HLSPlaylistDownloader *)dl didDownloadNewChunkForRemoteStream:(NSURL *)stream;
- (void) streamDownloader:(HLSPlaylistDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream;

// Error.
- (void) streamDownloader:(HLSPlaylistDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream;

@end
