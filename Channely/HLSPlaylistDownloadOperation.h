//
//  HLSPlaylistDownloadOperation.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSPlaylistDownloader.h"
#import "HLSPlaylistDownloaderDelegate.h"
#import "HLSStreamAdvertisingManager.h"
#import "ChanUtility.h"
#import "HLSPlaylistDownloadOperationDelegate.h"

@interface HLSPlaylistDownloadOperation : NSOperation <HLSPlaylistDownloaderDelegate>
@property (atomic, readonly) BOOL isExecuting;
@property (atomic, readonly) BOOL isFinished;
@property (strong) NSString *recordingId;
@property (readonly, weak) id<HLSPlaylistDownloadOperationDelegate> delegate;

- (id) initWithStreamId:(NSString *)rId forPlaylist:(NSURL *)playlistURL toDirectory:(NSString *)dir delegate:(id<HLSPlaylistDownloadOperationDelegate>)del;

@end
