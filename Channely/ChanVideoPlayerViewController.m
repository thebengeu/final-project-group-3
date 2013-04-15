//
//  ChanVideoPlayerViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPlayerViewController.h"

static NSString *const cAnnotationSegueId = @"annotationFromMPlayerSegue";
static NSString *const cMetaFormat = @"id:%@ from %@";

CGImageRef UIGetScreenImage(void); // Private API.

@interface ChanVideoPlayerViewController ()
@property (nonatomic) BOOL _parametersSet;
@property (strong) NSURL *_serverURL;
@property (strong) NSString *_recordingId;
@property (strong) NSURL *_selectedURL;
@property (strong) MPMoviePlayerController *_player;
@property (nonatomic) BOOL _firstLoad;
@property (strong) ChanChannel *_channel;

// P2P Peer Selection.
- (void) selectSource;

// Media Player.
- (void) attachPlayer;

// Screenshot.
- (UIImage *) getMediaPlayerScreenshot;

@end

@implementation ChanVideoPlayerViewController
@synthesize _parametersSet;
@synthesize _serverURL;
@synthesize _recordingId;
@synthesize _selectedURL;
@synthesize _player;
@synthesize _firstLoad;
@synthesize _channel;

#pragma mark View Controller Methods
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _parametersSet = NO;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// Note: There may be a race condition here if the parent does not call setServerURL: before the view appears.
- (void) viewDidAppear:(BOOL)animated {
    if (!_firstLoad) {
        return;
    }
    
    self.urlLabel.title = [NSString stringWithFormat:cMetaFormat, _recordingId, _selectedURL.host];
    
    if (!_parametersSet) {
        NSLog(@"Race condition in VideoPlayerViewController!");
    }
    
    [self attachPlayer];
    
    _firstLoad = NO;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:cAnnotationSegueId]) {
        ChanAnnotationViewController *vc = (ChanAnnotationViewController *)segue.destinationViewController;
        vc.image = [self getMediaPlayerScreenshot];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (_player) {
        _player.view.frame = self.contentView.bounds;
    }
}

#pragma mark One Time Use Methods
- (void) setServerURL:(NSString *)url forChannel:(ChanChannel *)channel {
    if (!_parametersSet) {
        _recordingId = [ChanUtility fileNameFromURLString:url];
        _serverURL = [NSURL URLWithString:url];
        _channel = channel;
        _parametersSet = YES;
        _firstLoad = YES;
        
        [self selectSource];
    }
}

#pragma mark P2P Peer Selection
- (void) selectSource {
    _selectedURL = [[HLSLoadBalancer loadBalancer] selectBestLocalHostForRecording:_recordingId default:_serverURL];

    // Select the server if no local client exists.
    // TODO - select the server if the local client has too few chunks.
    if (!_selectedURL) {
        _selectedURL = _serverURL;
    }
    
    NSLog(@"selected source=%@", _selectedURL);

    // Start P2P replication.
    [[HLSStreamSync streamSync] syncStreamId:_recordingId playlistURL:_selectedURL];
}

#pragma mark Media Player
- (void) attachPlayer {
    _player = [[MPMoviePlayerController alloc] initWithContentURL:_selectedURL];
    _player.view.frame = self.contentView.bounds;
    [self.contentView addSubview:_player.view];
    [_player play];
    [_player setFullscreen:YES animated:YES];
}

#pragma mark Event Handlers
- (IBAction) backButton_Action:(id)sender {
    [_player stop];
    
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

#pragma mark Screenshot
// Ref: http://stackoverflow.com/questions/2507220/code-example-for-iphone-uigetscreenimage
// Discussion: The underlying CALayer for MPMoviePlayerController.view does not fully implement QuartzCore methods
// for rendering an image of itself, and its sublayers, to a Context. We can determine which HLS chunk the user
// requested a screenshot in by considering the current playback time, and subtracting the length of chunks [0..n)
// until the remainder is less than the length of chunk n, which we conclude to be the current chunk. However, iOS
// cannot natively playback (and hence requestTumbnail from).ts MPEG transport streams, and since we do not store
// the raw .mp4 files locally, we cannot apply this technique to get a screenshot on the device itself.
// It would appear that the only way to get a screenshot is to make a callback to the server asynchronously, and
// wait for ffmpeg to process the file server-side. There is no easy way to coordinate this with the real-time UI
// for annotation.
// Note: The following private API precludes AppStore deployment.
// Footnote: fxck apple.
- (UIImage *) getMediaPlayerScreenshot {
//    NSLog(@"x:%lf, y:%lf, width:%lf, height:%lf", self.contentView.bounds.origin.x, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    NSLog(@"x:%lf, y:%lf, width:%lf, height:%lf", self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    CGImageRef screen = UIGetScreenImage();
    UIImage* screenImage = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    
    return screenImage;
}

@end
