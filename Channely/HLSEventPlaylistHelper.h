//
//  HLSEventPlaylistHelper.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides utility methods that operate on a HLS Playlist.
 */
@interface HLSEventPlaylistHelper : NSObject
/**
 Creates and initializes a `HLSEventPlaylistHelper`.
 
 @param url The URL of the playlist file to operate on.
 
 @return An initialized instance of this object.
 */
- (id)initWithFileURL:(NSURL *)url;

/**
 Writes the playlist header.
 
 @param period The target duration of an individual chunk. All chunks MUST have durations that are strictly less than this value.
 */
- (void)beginPlaylistWithTargetInterval:(NSUInteger)period;

/**
 Appends an untitled chunk to the playlist.
 
 @param path The path to the chunk. A path may be absolute or relative. If a path is absolute, it should be in the form of a URL.
 @param duration The duration of the chunk being appended.
 */
- (void)appendItem:(NSString *)path withDuration:(CGFloat)duration;

/**
 Appends a titled chunk to the playlist.
 
 @param path The path to the chunk. A path may be absolute or relative. If a path is absolute, it should be in the form of a URL.
 @param duration The duration of the chunk being appended.
 @param title The title of the chunk being appended.
 */
- (void)appendItem:(NSString *)path withDuration:(CGFloat)duration withTitle:(NSString *)title;

/**
 Writes the playlist footer. No additional chunks may be appended to a playlist after this method is called.
 */
- (void)endPlaylist;


/**
 Determines if the HLS playlist at the specified path is complete.
 
 @param path The path of the specified playlist.
 
 @return `YES` if the playlist contains the playlist footer. A `NO` may be returned if the playlist could not be read.
 */
+ (BOOL)playlistIsComplete:(NSString *)path;

/**
 Determines the number of chunks in the playlist.
 
 @param path The path of the specified playlist.
 
 @return The number of chunks in the playlist. A `0` may be returned if the playlist could not be read.
 */
+ (NSUInteger)playlistChunkCount:(NSString *)path;

@end
