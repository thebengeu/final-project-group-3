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
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didStartDownloadingRemoteStream:(NSURL *)stream;
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didDownloadNewChunkForRemoteStream:(NSURL *)stream;
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didFinishDownloadingRemoteStream:(NSURL *)stream;

// Error.
- (void)playlistDownloader:(HLSPlaylistDownloader *)dl didTimeoutWhenDownloadingRemoteStream:(NSURL *)stream;

@end
