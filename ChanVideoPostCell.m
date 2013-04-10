//
//  ChanVideoPostCell.m
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPostCell.h"

@interface ChanVideoPostCell ()
@property (strong) NSString *_recordingId;
@property (strong) NSString *_serverURL;
@property (strong) MPMoviePlayerViewController *_moviePlayer;

- (void) setPost:(ChanPost *)post;

@end

@implementation ChanVideoPostCell
@synthesize _recordingId;
@synthesize _serverURL;
@synthesize _moviePlayer;

- (void) setPost:(ChanPost *)post {
    [super setPost:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    _serverURL = videoPost.url;
    _recordingId = [ChanUtility fileNameFromURLString:_serverURL];
    
    self.textContent.text = [NSString stringWithFormat:@"Placeholder for recordingId:%@", _recordingId];
}

- (IBAction) viewButtonEventHandler:(id)sender {
    NSURL *selectedURL = [[HLSLoadBalancer loadBalancer] selectBestLocalHostForRecording:_recordingId];
    
    // Select the server if no local client exists.
    // TODO - select the server if the local client has too few chunks.
    if (!selectedURL) {
        selectedURL = [NSURL URLWithString:_serverURL];
    }
    
    // P2P replication.
    [[HLSStreamSync streamSync] syncStreamId:_recordingId playlistURL:selectedURL];
    
    // Play media.
    // TODO
}

@end
