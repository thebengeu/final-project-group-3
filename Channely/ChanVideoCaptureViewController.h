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
#import "ChanPostViewController.h"

@interface ChanVideoCaptureViewController : UIViewController <ChunkingVideoRecorderDelegate>
// Storyboard.
@property (strong, nonatomic) IBOutlet UIView *previewArea;
@property (strong, nonatomic) IBOutlet UIButton *recordingButton;
@property (weak, nonatomic) id<ChanPostViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *liveText;

// External.
@property (strong) ChanChannel *parentChannel;
@property (atomic, readonly) BOOL isExpectingFirstChunk;

- (IBAction)recordingControlButton_Action:(id)sender;

// REST API
- (void)didReceiveCurrentRecording:(ChanHLSRecording *)recording;
- (void)didReceiveFirstTranscodedChunk:(ChanHLSChunk *)chunk;

@end
