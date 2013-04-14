//
//  ChanVideoCaptureViewController.h
//  Channely
//
//  Created by Cedric on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TimedChunkingVideoRecorder.h"
#import "ChunkingVideoRecorderDelegate.h"
#import "HLSStreamSync.h"
#import "ChanHLSRecording.h"
#import "ChanChannel.h"
#import "ChanHLSChunk.h"
#import "ChanUtility.h"
#import "ChannelViewControllerDelegate.h"

@interface ChanVideoCaptureViewController : UIViewController <ChunkingVideoRecorderDelegate>
// Storyboard.
@property (strong, nonatomic) IBOutlet UIView *previewArea;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *recordingControlButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) id<ChannelViewControllerDelegate> delegate;


// External.
@property (strong) ChanChannel *parentChannel;
@property (atomic, readonly) BOOL isExpectingFirstChunk;

- (IBAction)recordingControlButton_Action:(id)sender;
- (IBAction)backButton_Action:(id)sender;

// REST API
- (void) didReceiveCurrentRecording:(ChanHLSRecording *)recording;
- (void) didReceiveFirstTranscodedChunk:(ChanHLSChunk *)chunk;

@end
