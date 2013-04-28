//
//  ChunkingVideoRecorder.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

@protocol ChunkingVideoRecorderDelegate;

/**
 A video capture object that can split video files into chunks while recording. 
 */
@interface ChunkingVideoRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>
@property (weak) id<ChunkingVideoRecorderDelegate> delegate;
@property (atomic, readonly) BOOL isPreviewing;
@property (atomic, readonly) BOOL isRecording;
@property (readonly, strong) AVCaptureVideoPreviewLayer *previewLayer;

/**
 Creates and initializes a `ChunkingVideoRecorder`.
 
 @param preset The quality preset to record at.
 
 @return An initialized instance of this object.
 */
- (id)initWithPreset:(NSString *)preset;

/**
 Starts the camera so that a preview image may be displayed in the User Interface.
 
 @return The preview layer which may be added to a `CALayer` hierarchy for display.
 */
- (AVCaptureVideoPreviewLayer *)startPreview;

/**
 Stops the preview image.
 */
- (void)stopPreview;

/**
 Starts video capture to a target directory. Files are written with a monotonically increasing sequence number that starts at zero.
 
 @param directory The target directory.
 */
- (void)startRecordingToDirectory:(NSString *)directory;

/**
 Stops video capture by writing the last chunk to the target directory,
 */
- (void)stopRecording;

/**
 Chunks a video. Stops recording to the current file, writes the file to the target directory, and starts recording to a new file with an incremented sequence number.
 */
- (void)chunk;

@end
