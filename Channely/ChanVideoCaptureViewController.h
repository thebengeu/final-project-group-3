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

@interface ChanVideoCaptureViewController : UIViewController <ChunkingVideoRecorderDelegate>
@property (strong, nonatomic) IBOutlet UIView *previewArea;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *recordingControlButton;

- (IBAction)recordingControlButton_Action:(id)sender;
- (IBAction)backButton_Action:(id)sender;

@end
