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
// Redefinitions.
@property (atomic, readwrite) BOOL isExpectingFirstChunk;

// Internal.
@property (strong) TimedChunkingVideoRecorder *_recorder;
@property (nonatomic) BOOL _isRecording;
@property (strong) ChanHLSRecording *_currentRecording;

// UI Utility
- (void) updateRecordingControlButtonState;
- (void) updatePreviewRotationToOrientation;

// Video Capture
- (void) startPreviewing;
- (void) stopPreviewing;
- (void) startRecording;
- (void) stopRecording;

@end

@implementation ChanVideoCaptureViewController
// Redefinitions.
@synthesize isExpectingFirstChunk;

// External.
@synthesize parentChannel;

// Internal.
@synthesize _recorder;
@synthesize _isRecording;
@synthesize _currentRecording;

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
    
    _recorder = [[TimedChunkingVideoRecorder alloc] initWithPreset:AVCaptureSessionPresetMedium];
    _recorder.delegate = self;
    
    _isRecording = NO;
    
    [self updateRecordingControlButtonState];
}

- (void) viewDidAppear:(BOOL)animated {
    // Prevent device from going to sleep.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self startPreviewing];
    
    [self updatePreviewRotationToOrientation];
    _recorder.previewLayer.frame = self.previewArea.frame;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updatePreviewRotationToOrientation];
    _recorder.previewLayer.frame = self.previewArea.frame;
}

// Videos should be in landscape format.
- (BOOL) shouldAutorotate {
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark Event Handlers
- (IBAction)recordingControlButton_Action:(id)sender {
    if (_isRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
    
    [self updateRecordingControlButtonState];
}

- (IBAction)backButton_Action:(id)sender {
    if (_isRecording) {
        [self stopRecording];
    }
    
    // Allow device to go back to sleep when we are no longer in the camera context.
    // We assume that the 'back' button is the only way to exit the camera software.
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
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

- (void) updatePreviewRotationToOrientation {
    CGFloat transformAngle;
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transformAngle = M_PI / 2.;
            break;
        case UIInterfaceOrientationLandscapeRight:
            transformAngle = -M_PI / 2.;
            break;
        case UIInterfaceOrientationPortrait:
            transformAngle = 0.;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transformAngle = M_PI;
            break;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(transformAngle);
    _recorder.previewLayer.affineTransform = transform;
}

#pragma mark Logic
- (void) startPreviewing {
    AVCaptureVideoPreviewLayer *layer = [_recorder startPreview];
    
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.previewArea.layer addSublayer:layer];
    
    NSLog(@"start previewing. channelid=%@, target=%@ target.layer=%@ preview.layer=%@", parentChannel.id, self.previewArea, self.previewArea.layer, layer); // DEBUG
}

- (void) stopPreviewing {
    [_recorder stopPreview];
}

- (void) startRecording {
    [_recorder startTimedRecordingToDirectory:[ChanUtility videoTempDirectory] chunkInterval:cChunkPeriod];
    
    _isRecording = YES;
}

- (void) stopRecording {
    [_recorder stopRecording];
    
    _isRecording = NO;
}

#pragma mark Chunking Video Recorder Delegate
- (void) recorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration {
    NSLog(@"local video recording did chunk. index=%d", index);
    
    if (!_currentRecording) {
        NSLog(@"video capture. in recorderDidChunk: current recording does not exist!");
        return;
    }
    
    ChanVideoCaptureViewController *vc = self;
    NSData *chunkData = [NSData dataWithContentsOfURL:chunk];
    
    [_currentRecording addChunkWithData:chunkData duration:duration seqNo:index withCompletion:^(ChanHLSChunk *hlsChunk, NSError *error) {
        if (error) {
            NSLog(@"video capture. in recorderDidChunk: REST error.");
            return;
        }
        
        if (vc.isExpectingFirstChunk) {
            [vc didReceiveFirstTranscodedChunk:hlsChunk];
        }
    }];
}

- (void) recorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration {
    NSLog(@"local video recording stopped.");
    
    if (!_currentRecording) {
        NSLog(@"video capture. in recorderDidStopRecording: current recording does not exist!");
        return;
    }
    
    NSData *chunkData = [NSData dataWithContentsOfURL:chunk];
    
    [_currentRecording addChunkWithData:chunkData duration:duration seqNo:index withCompletion:^(ChanHLSChunk *hlsChunk, NSError *error) {
        if (error) {
            NSLog(@"video capture. in recorderDidStopRecording: REST error.");
            return;
        }
    }];
    
    [_currentRecording stopRecordingWithEndDate:[NSDate date] endSeqNo:index withCompletion:^(ChanHLSRecording *hlsRecording, NSError *error) {
        return;
    }];
}

- (void) recorderDidStartRecording:(ChunkingVideoRecorder *)recorder {
    NSLog(@"local video recording started.");
    
    isExpectingFirstChunk = YES;
    ChanVideoCaptureViewController *vc = self;
    
    [ChanHLSRecording createRecordingWithStartDate:[NSDate date] channelId:parentChannel.id withCompletion:^(ChanHLSRecording *hlsRecording, NSError *error) {
        if (!error) {
            [vc didReceiveCurrentRecording:hlsRecording];
        } else {
            NSLog(@"video capture. in recorderDidStartRecording: REST error.");
        }
    }];
}

#pragma mark REST API
- (void) didReceiveCurrentRecording:(ChanHLSRecording *)recording {
    NSLog(@"received current recording from server. playlist=%@", recording.playlistURL); // DEBUG
    
    _currentRecording = recording;
}

- (void) didReceiveFirstTranscodedChunk:(ChanHLSChunk *)chunk {
    NSLog(@"received first transcoded chunk from server."); // DEBUG
    
    NSURL *playlistURL = [NSURL URLWithString:_currentRecording.playlistURL];
    HLSStreamSync *sync = [HLSStreamSync streamSync];
    
    NSLog(@"sync=%@", sync); // DEBUG
    
    [sync syncStreamId:_currentRecording.id playlistURL:playlistURL];
    
    isExpectingFirstChunk = NO;
}

@end
