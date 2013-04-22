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

@interface ChanMenuSignupViewController ()

@end

@implementation ChanMenuSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_submitButton setType:BButtonTypeChan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender
{
    if (![_status isAnimating]) {
        if ([[_username text]length] == 0 || [[_password text]length] == 0) {
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Signup" message:@"Invalid username or password"];
            __weak AHAlertView *weakA = alert;
            [alert setCancelButtonTitle:@"OK" block:^{
                weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
            }];
            [alert show];
            return;
        }
        
        [ChanUser createUserWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
            [_status stopAnimating];
            if (error) {
                AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Signup" message:@"Invalid username or password"];
                __weak AHAlertView *weakA = alert;
                [alert setCancelButtonTitle:@"OK" block:^{
                    weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
                }];
                [alert show];
            } else {
                [ChanUser getAccessTokenWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
                    if (error) {
                        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Login" message:@"Error while logging in"];
                        __weak AHAlertView *weakA = alert;
                        [alert setCancelButtonTitle:@"OK" block:^{
                            weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
                        }];
                        [alert show];
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
