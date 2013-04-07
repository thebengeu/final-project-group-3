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
- (void) startPreviewing;
- (void) stopPreviewing;
- (void) startRecording;
- (void) stopRecording;

@end

@implementation ChanVideoCaptureViewController
// Storyboard.
//@synthesize previewArea;
//@synthesize recordingControlButton;

// Internal.
@synthesize _recorder;
@synthesize _isRecording;

#pragma mark View Controller Methods
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _recorder = [[TimedChunkingVideoRecorder alloc] initWithPreset:AVCaptureSessionPresetHigh];
    _recorder.delegate = self;
    
    _isRecording = NO;
    
    [self updateRecordingControlButtonState];
}

- (void) viewDidAppear:(BOOL)animated {
    [self startPreviewing];
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

#pragma mark Logic
- (void) startPreviewing {
    AVCaptureVideoPreviewLayer *layer = [_recorder startPreview];
    
    layer.frame = self.previewArea.frame;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.previewArea.layer addSublayer:layer];
    
    NSLog(@"start previewing. target=%@ target.layer=%@ preview.layer=%@", self.previewArea, self.previewArea.layer, layer); // DEBUG
}

- (void) stopPreviewing {
    [_recorder stopPreview];
}

- (void) startRecording {
    // TODO - start recording.
    
    _isRecording = NO;
}

- (void) stopRecording {
    // TODO - stop recording.
    
    _isRecording = YES;
}

#pragma mark Chunking Video Recorder Delegate
- (void) recorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration {
    
}

- (void) recorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration {
    
}

- (void) recorderDidStartRecording:(ChunkingVideoRecorder *)recorder {
    
}

@end