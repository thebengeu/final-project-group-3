//
//  ChanMenuSignupViewController.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuSignupViewController.h"
#import "ChanUser.h"
#import "SVProgressHUD.h"
#import "AHAlertView+Channely.h"
#import "BButton.h"
#import "Constants.h"

@implementation ChanMenuSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_submitButton setType:BButtonTypeChan];
}

- (IBAction)submit:(id)sender
{
    if (![_status isAnimating]) {
        if ([[_username text]length] == 0 || [[_password text]length] == 0) {
            [AHAlertView showTumbleAlertWithTitle:kUserMenuSignupAlertTitle message:kUserMenuAlertInvalidUsernamePasswordMessage];
            return;
        }
        
        [ChanUser createUserWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
            [_status stopAnimating];
            if (error) {
                [AHAlertView showTumbleAlertWithTitle:kUserMenuSignupAlertTitle message:kUserMenuAlertInvalidUsernamePasswordMessage];
            } else {
                [ChanUser getAccessTokenWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
                    if (error) {
                        [AHAlertView showTumbleAlertWithTitle:kUserMenuLoginAlertTitle message:kUserMenuLoginErrorTitle];
                    } else {
                        [[self navigationController] popViewControllerAnimated:YES];
                        [SVProgressHUD showSuccessWithStatus:@"Welcome!"];
                    }
                }];
            }
        }];
        
        [_status startAnimating];
    }
}

@end
