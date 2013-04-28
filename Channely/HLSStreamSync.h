//
//  HLSStreamSync.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSPlaylistDownloadOperation.h"
#import "ChanUtility.h"
#import "HLSEventPlaylistHelper.h"
#import "HLSStreamAdvertisingManager.h"
#import "HLSPlaylistDownloadOperationDelegate.h"
#import "Constants.h"

/**
 `HLSStreamSync` is a component that runs in the background and manages the downloading and subsequent propagation of video streams.
 */
@interface HLSStreamSync : NSObject <HLSPlaylistDownloadOperationDelegate>
/**
 Returns `nil`. `HLSStreamSync` is a singleton.
 
 @return `nil`.
 */
- (id)init;

/**
 Returns the number of operations currently in the `HLSStreamSync`'s operation queue.
 
 @return Number of pending operations.
 */
- (NSUInteger)operationCount;

/**
 Instructs this object to begin downloading and propagating a new stream.
 
 @param sId The globally unique id of the video recording.
 @param playlist The URL of the playlist file on the source.
 */
- (void)syncStreamId:(NSString *)sId playlistURL:(NSURL *)playlist;

/**
 Deteremines if a complete stream for a specified id already exists on the local device.
 
 @param sId The stream to query.
 
 @return `YES` if such a stream exists, `NO` otherwise.
 */
- (BOOL)completeLocalStreamExistsForStreamId:(NSString *)sId;

/**
 Instructs this object to inspect its media directory for exisiting streams. Complete streams are re-advertised, corrupted or incomplete streams are deleted, and streams older than a threshold are also removed.
 */
- (void)recheckExistingStreams;


/**
 Returns a reference to an existing copy of `HLSStreamSync`. If no such copy exists, returns `nil`.
 
 @return An initialized instance of this object, or `nil`.
 */
+ (HLSStreamSync *)streamSync;

/**
 Initializes a single instance of `HLSStreamSync` and returns a reference to it. If the object has already been initialized, then this method returns a reference to the existing copy.
 
 @param dir The media directory of this object. Downloaded recordings are placed in subfolders of this directory. The name of each subfolder is its recording id.
 
 @return An initialized instance of this object.
 */
+ (HLSStreamSync *)setupStreamSyncWithBaseDirectory:(NSString *)dir;

@end
