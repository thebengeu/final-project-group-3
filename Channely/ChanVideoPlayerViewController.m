//
//  ChanVideoPlayerViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPlayerViewController.h"

@interface ChanVideoPlayerViewController ()
@property (nonatomic) BOOL _parametersSet;
@property (strong) NSURL *_serverURL;
@property (strong) NSString *_recordingId;
@property (strong) NSURL *_selectedURL;
@property (strong) MPMoviePlayerController *_player;
@property (nonatomic) BOOL _firstLoad;

// P2P Peer Selection.
- (void) selectSource;

// Media Player.
- (void) attachPlayer;

@end

@implementation ChanVideoPlayerViewController
@synthesize _parametersSet;
@synthesize _serverURL;
@synthesize _recordingId;
@synthesize _selectedURL;
@synthesize _player;
@synthesize _firstLoad;

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

#pragma mark One Time Use Methods
- (void) setServerURL:(NSString *)url {
    if (!_parametersSet) {
        _recordingId = [ChanUtility fileNameFromURLString:url];
        _serverURL = [NSURL URLWithString:url];
        _parametersSet = YES;
        _firstLoad = YES;
        
        [self selectSource];
    }
}

#pragma mark P2P Peer Selection
- (void) selectSource {
    _selectedURL = [[HLSLoadBalancer loadBalancer] selectBestLocalHostForRecording:_recordingId];

    // Select the server if no local client exists.
    // TODO - select the server if the local client has too few chunks.
    if (!_selectedURL) {
        _selectedURL = _serverURL;
    }

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
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

@end
