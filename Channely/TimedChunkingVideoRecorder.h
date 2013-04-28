//
//  TimedChunkingVideoRecorder.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChunkingVideoRecorder.h"

/**
 A video recorder that chunks at regular intervals.
 */
@interface TimedChunkingVideoRecorder : ChunkingVideoRecorder
@property (atomic, readonly) CGFloat interval;

/**
 Creates and initializes a `TimedChunkingVideoRecorder`.
 
 @param preset The quality preset to record at.
 
 @return An initialized instance of this object.
 */
- (id)initWithPreset:(NSString *)preset;

/**
 Starts video capture to a target directory. Files are written with a monotonically increasing sequence number that starts at zero. The video recorder automatically chunks at every defined interval.
 
 @param directory The target directory.
 @param period The interval in seconds at which the video recorder performs a chunk.
 */
- (void)startTimedRecordingToDirectory:(NSString *)directory chunkInterval:(CGFloat)period;

/**
 Stops video capture by writing the last chunk to the target directory,
 */
- (void)stopRecording;

@end
