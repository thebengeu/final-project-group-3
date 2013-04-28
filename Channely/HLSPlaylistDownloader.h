//
//  HLSDownloader.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSChunkDownloadOperation.h"
#import "HLSChunkDownloadMetaData.h"
#import "HLSEventPlaylistHelper.h"
#import "HLSPlaylistDownloaderDelegate.h"
#import "Constants.h"

/**
 Downloads a playlist while maintaining an invariant that a partially downloaded playlist must be valid and playable at all times.
 */
@interface HLSPlaylistDownloader : NSObject
@property (atomic, readonly) BOOL isConsumed;

/**
 Creates and initializes a `HLSPlaylistDownloader`.
 
 @param playlist The URL of the playlist to download.
 @param delegate A delegate that listens to state changes on this object. If no delegate is required, pass in `nil`.
 
 @return An initialized instance of this object.
 */
- (id)initWithPlaylist:(NSURL *)playlist delegate:(id<HLSPlaylistDownloaderDelegate>)delegate;

/**
 Begins downloading the playlist specified at initalization to a local directory.
 
 @param directory The destination directory.
 */
- (void)downloadToDirectory:(NSString *)directory;

@end
