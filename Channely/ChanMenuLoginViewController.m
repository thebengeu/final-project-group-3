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
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Login" message:@"Invalid username or password"];
            __weak AHAlertView *weakA = alert;
            [alert setCancelButtonTitle:@"OK" block:^{
                weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
            }];
            [alert show];
            return;
        }
        
        [ChanUser getAccessTokenWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
            [_status stopAnimating];
            if (error != nil) {
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Login" message:@"Invalid Username or Password"];
                __weak AHAlertView *weakA = alert;
                [alert setCancelButtonTitle:@"OK" block:^{
                    weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
                }];
                [alert show];
            } else {
                [[self navigationController]popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"Welcome back"];
            }
        }];
        
        [_status startAnimating];
    }
}

@end
