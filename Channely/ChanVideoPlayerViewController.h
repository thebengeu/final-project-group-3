//
//  ChanVideoPlayerViewController.h
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ChanChannel.h"
#import "ChanUtility.h"
#import "HLSLoadBalancer.h"
#import "HLSStreamSync.h"
#import "ChanAnnotationViewController.h"

@interface ChanVideoPlayerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void) setServerURL:(NSString *)url forChannel:(ChanChannel *)channel;

- (IBAction)backButton_Action:(id)sender;

@end
