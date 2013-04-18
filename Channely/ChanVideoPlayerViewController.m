//
//  ChanVideoPlayerViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ChanVideoInfoViewController.h"

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
@property UIPopoverController *infoPopover;
@property UIBarButtonItem *infoButton;

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
    
    //  Bar items for annotation
    NSMutableArray *rightBarItems = [[NSMutableArray alloc]initWithArray:[self navigationItem].rightBarButtonItems];
    
    UIBarButtonItem *annotateButton = [[UIBarButtonItem alloc]initWithTitle:@"Annotate" style:UIBarButtonItemStylePlain target:self action:@selector(annotate)];
    [rightBarItems addObject:annotateButton];
    
    _infoButton = [[UIBarButtonItem alloc]initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(info)];
    [rightBarItems addObject:_infoButton];
    
    self.navigationItem.rightBarButtonItems = rightBarItems;
}

// Note: There may be a race condition here if the parent does not call setServerURL: before the view appears.
- (void) viewDidAppear:(BOOL)animated {
    if (_firstLoad) {
        if (!_parametersSet) {
            NSLog(@"Race condition in VideoPlayerViewController!");
        }
    
        [self attachPlayer];
        _firstLoad = NO;
    }
}


-(void) viewWillDisappear:(BOOL)animated{
    [_infoPopover dismissPopoverAnimated:YES];
    _infoPopover = nil;
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
    _selectedURL = [HLSLoadBalancer selectBestLocalHostForRecording:_recordingId default:_serverURL];
    
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
    
    _player.controlStyle = MPMovieControlStyleEmbedded;
}


#pragma mark Annotation
- (void) annotate {
    //  Pause if video is not streaming
    if ([[HLSStreamSync streamSync] completeLocalStreamExistsForStreamId :_recordingId] == YES)
        [_player pause];
    [[self delegate]launchAnnotationForImagePost:[self getMediaPlayerScreenshot]];
}

#pragma mark Info
- (void) info {
    if (_infoPopover != nil)
        return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanVideoInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChanVideoInfoViewController"];
    controller.recordingIdText = _recordingId;
    controller.hostText = _selectedURL.host;
    controller.resolutionText = [NSString stringWithFormat:@"%fx%f", [_player naturalSize].width, [_player naturalSize].height];
    
    _infoPopover = [[UIPopoverController alloc]initWithContentViewController:controller];
    _infoPopover.delegate = self;
    [_infoPopover presentPopoverFromBarButtonItem:_infoButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark Info
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (_infoPopover == popoverController)
        _infoPopover = nil;
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
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (([[UIApplication sharedApplication] statusBarOrientation])) {
        case UIInterfaceOrientationLandscapeLeft:
            orientation = UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            orientation = UIImageOrientationLeft;
            break;
        case UIInterfaceOrientationPortrait:
            orientation = UIImageOrientationUp;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            orientation = UIImageOrientationDown;
            break;
        default:
            break;
    }
    
    CGRect playerFrame = [_player view].frame;
    CGSize videoSize = [_player naturalSize];
    CGPoint position = CGPointMake(0, 64);  //  Hardcoded navigation bar size + status bar size
    
    CGFloat scale;
    CGRect frame;
    scale = MIN(playerFrame.size.width/videoSize.width, playerFrame.size.height/videoSize.height);
    videoSize.width *= scale;
    videoSize.height *= scale;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        frame = CGRectMake((playerFrame.size.width-videoSize.width)/2.0 + position.x,
                           (playerFrame.size.height-videoSize.height)/2.0 + position.y,
                           videoSize.width,
                           videoSize.height);
    else
        frame = CGRectMake((playerFrame.size.height-videoSize.height)/2.0 + position.x,
                           (playerFrame.size.width-videoSize.width)/2.0,    //  Yet another hardcode
                           videoSize.height,
                           videoSize.width);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(screen, frame);
    UIImage* outImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:orientation];

    CGImageRelease(screen);
    CGImageRelease(imageRef);
    return outImage;
}

@end
