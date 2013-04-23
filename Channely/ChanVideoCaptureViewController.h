//
//  ChanVideoCaptureViewController.h
//  Channely
//
//  Created by Cedric on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChunkingVideoRecorderDelegate.h"
#import "BButton.h"

@class ChanChannel;
@class ChanHLSRecording;
@class ChanHLSChunk;
@protocol ChanPostViewControllerDelegate;

@interface ChanVideoCaptureViewController : UIViewController <ChunkingVideoRecorderDelegate>
// Storyboard.
@property (strong, nonatomic) IBOutlet UIView *previewArea;
@property (strong, nonatomic) IBOutlet BButton *recordingButton;
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
