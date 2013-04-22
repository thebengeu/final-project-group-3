//
//  ChanMenuUserViewController.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuUserViewController.h"
#import "ChanMenuAnonUserViewController.h"
#import "ChanUser.h"
#import "SVProgressHUD.h"
#import "AHAlertView.h"
#import "BButton.h"
#import "Constants.h"

@interface ChanMenuUserViewController ()

@end

@implementation ChanMenuUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([ChanUser loggedInUser] == nil) {
        [self switchToAnonUserViewController];
        return;
    }
    
    // Set Navbar items
    [[self navigationItem] setTitle:@"User Settings"];
    [_username setText:[[ChanUser loggedInUser] name]];
    
    // Set button styles
    [_editChannelButton setType:BButtonTypeWarning];
    [_logoutButton setType:BButtonTypeInverse];
    [_updateButton setType:BButtonTypeChan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([ChanUser loggedInUser] == nil) [self switchToAnonUserViewController];
}

- (void)switchToAnonUserViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    ChanMenuAnonUserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChanMenuAnonUserViewController"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    [viewControllers removeObject:self];
    [viewControllers addObject:userViewController];
    [self.navigationController setViewControllers:viewControllers];
}

- (IBAction)update:(id)sender
{
    if (![_updateStatus isAnimating]) {
        if ([[_username text]length] == 0) {
            AHAlertView *alert = [[AHAlertView alloc] initWithTitle:@"Update" message:@"Invalid username"];
            __weak AHAlertView *weakA = alert;
            [alert setCancelButtonTitle:@"OK" block:^{
                weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
            }];
            [alert show];
            return;
        }
        
        NSString *password = [_password text];
        if ([password length] == 0) password = nil;
        
        //  Sends request to API
        [[ChanUser loggedInUser]updateUser:[_username text] password:password withCompletion:^(ChanUser *user, NSError *error) {
            [_updateStatus stopAnimating];
            [_username setText:[[ChanUser loggedInUser]name]];
            [_password setText:@""];
            [SVProgressHUD showSuccessWithStatus:@"Updated"];
        }];
        
        [_updateStatus startAnimating];
    }
}

- (IBAction)logout:(id)sender
{
    [ChanUser logout];
    [self switchToAnonUserViewController];
    [SVProgressHUD showSuccessWithStatus:@"Logged out"];
}

@end
