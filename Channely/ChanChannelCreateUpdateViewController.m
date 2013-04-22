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
#import "AHAlertView+Channely.h"
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
        [_deleteButton setType:BButtonTypeInverse];
    } else {
        [_createUpdateButton setTitle: kCreateChannelButtonTitle forState:UIControlStateNormal];
        [[self navigationItem] setTitle: kCreateChannelNavigationTitle];
        [_deleteButton removeFromSuperview];
    }
}

- (IBAction)createOrUpdate:(id)sender
{
    if ([[_channelName text]length] == 0) {
        [AHAlertView showTumbleAlertWithTitle:kCreateChannelEmptyChannelNameAlertTitle message:kCreateChannelEmptyChannelNameAlertMessage];
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

- (IBAction)deleteChannel:(id)sender {
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Delete Channel" message:[NSString stringWithFormat:@"Are you sure you want to delete %@?", [_channel name]]];
    __weak AHAlertView *weakA = alert;
    [alert setCancelButtonTitle:kCancelButtonTitle block:^{
        weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
    }];
    
    NSString *channelName = [_channel name];
    [alert addButtonWithTitle:kOkButtonTitle block:^{
        [_channel deleteWithCompletion:^(ChanChannel *channel, NSError *error) {
            weakA.dismissalStyle = AHAlertViewDismissalStyleZoomOut;
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:kDeleteChannelCompletedMessageFormat, channelName]];
            [[self navigationController]popViewControllerAnimated:YES];
        }];
    }];
    [alert show];
}

@end
