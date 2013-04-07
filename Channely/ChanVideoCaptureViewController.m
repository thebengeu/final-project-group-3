//
//  ChanVideoCaptureViewController.m
//  Channely
//
//  Created by Cedric on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoCaptureViewController.h"

static CGFloat const cChunkPeriod = 10.0f; // Duration of each chunk in seconds.
static NSString *const cButtonStopRecording = @"Stop";
static NSString *const cButtonStartRecording = @"Start";

@interface ChanVideoCaptureViewController ()
// Internal.
@property (strong) TimedChunkingVideoRecorder *_recorder;
@property (nonatomic) BOOL _isRecording;

// UI Utility
- (void) updateRecordingControlButtonState;

// Video Capture
- (void) startRecording;
- (void) stopRecording;

@end

@implementation ChanVideoCaptureViewController
// Internal.
@synthesize _recorder;
@synthesize _isRecording;

#pragma mark Constructors
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _recorder = [[TimedChunkingVideoRecorder alloc] initWithPreset:AVCaptureSessionPresetHigh];
        _isRecording = NO;
    }
    return self;
}

#pragma mark View Controller Methods
- (void) viewDidLoad {
    [super viewDidLoad];
	
    [_recorder startPreview];
}

- (void) viewDidAppear:(BOOL)animated {
    // TODO - attach preview layer.
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Event Handlers
- (IBAction)recordingControlButton_Action:(id)sender {
    if (_isRecording) {
        [self startRecording];
    } else {
        [self stopRecording];
    }
    
    [self updateRecordingControlButtonState];
}

- (IBAction)backButton_Action:(id)sender {
    if (_isRecording) {
        [self stopRecording];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

#pragma mark UI Utility
- (void) updateRecordingControlButtonState {
    if (_isRecording) {
        self.recordingControlButton.title = cButtonStopRecording;
    } else {
        self.recordingControlButton.title = cButtonStartRecording;
    }
}

#pragma mark Video Capture
- (void) startRecording {
    // TODO - start recording.
    
    _isRecording = NO;
}

- (void) stopRecording {
    // TODO - stop recording.
    
    _isRecording = YES;
}

@end
