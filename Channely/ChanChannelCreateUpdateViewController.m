//
//  ChanChannelCreateUpdateViewController.m
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanChannelCreateUpdateViewController.h"
#import "ChanChannel.h"
#import "ChanDetailViewController.h"
#include "SVProgressHUD.h"
#import "Constants.h"
#import "AHAlertView.h"
#import "ChanChannel.h"
#import "BButton.h"

@implementation ChanChannelCreateUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isUpdateChannel = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set button style
    [_createUpdateButton setType:BButtonTypeChan];
    
    
    if (_isUpdateChannel) {
        [_channelName setText:[_channel name]];
        [_hashtag setText:[_channel hashTag]];
    } else {
        [_createUpdateButton setTitle: kCreateChannelButtonTitle forState:UIControlStateNormal];
        [[self navigationItem] setTitle: kCreateChannelNavigationTitle];
    }
}

- (IBAction)createOrUpdate:(id)sender
{
    if ([[_channelName text]length] == 0) {
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:kCreateChannelEmptyChannelNameAlertTitle message:kCreateChannelEmptyChannelNameAlertMessage];
        __weak AHAlertView *weakA = alert;
        [alert setCancelButtonTitle:kOkButtonTitle block:^{
            weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
        }];
        [alert show];
        return;
    }
    
    if (_isUpdateChannel) {
        id me = self;
        [_channel updateChannelWithName:[_channelName text] hashTag:[_hashtag text] withCompletion:^(ChanChannel *channel, NSError *error) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:kUpdateChannelCompletedMessageFormat, [channel name]]];
            [[me navigationController]popToRootViewControllerAnimated:YES];
        }];
    } else {
        id me = self;
        [ChanChannel addChannelWithName:[_channelName text] hashTag:[_hashtag text] withCompletion:^(ChanChannel *channel, NSError *error) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:kCreateChannelCompletedMessageFormat, [channel name]]];
            [[me navigationController]popToRootViewControllerAnimated:YES];
        }];
    }
}

@end
