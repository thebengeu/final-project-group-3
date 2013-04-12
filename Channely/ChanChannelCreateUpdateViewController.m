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
#import "ChanMenuViewController.h"

@interface ChanChannelCreateUpdateViewController ()

@end

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
	// Do any additional setup after loading the view.
    
    
    if (_isUpdateChannel){
        [_channelName setText:[_channel name]];
        [_hashtag setText:[_channel hashTag]];
    } else {
        [_createUpdateButton setTitle:@"Create" forState:UIControlStateNormal];
        [[self navigationItem] setTitle:@"Create Channel"];
    }
}



- (IBAction)createOrUpdate:(id)sender {
    if ([[_channelName text]length] == 0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                          message:@"Channel Name must not be empty"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    if (_isUpdateChannel){
        id me = self;
        [_channel updateChannelWithName:[_channelName text] hashTag:[_hashtag text] withCompletion:^(ChanChannel *channel, NSError *error){
            [[me navigationController]popToRootViewControllerAnimated:YES];
        }];
    }else {
        id me = self;
        [ChanChannel addChannelWithName:[_channelName text] hashTag:[_hashtag text] withCompletion:^(ChanChannel *channel, NSError *error){
            [[me navigationController]popToRootViewControllerAnimated:YES];
        }];
    }
}

@end
