//
//  ChanMenuLoginViewController.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuLoginViewController.h"
#import "ChanUser.h"
#import "SVProgressHUD.h"
#import "AHAlertView+Channely.h"
#import "BButton.h"
#import "Constants.h"

@implementation ChanMenuLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_submitButton setType:BButtonTypeChan];
}

- (IBAction)submit:(id)sender
{
    if (![_status isAnimating]) {
        if ([[_username text]length] == 0 || [[_password text]length] == 0) {
            [AHAlertView showTumbleAlertWithTitle:kUserMenuLoginAlertTitle message:kUserMenuAlertInvalidUsernamePasswordMessage];
            return;
        }
        
        [ChanUser getAccessTokenWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
            [_status stopAnimating];
            if (error != nil) {
                [AHAlertView showTumbleAlertWithTitle:kUserMenuLoginAlertTitle message:kUserMenuAlertInvalidUsernamePasswordMessage];
            } else {
                [[self navigationController]popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"Welcome back"];
            }
        }];
        
        [_status startAnimating];
    }
}

@end
