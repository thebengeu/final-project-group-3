//
//  ChanMenuViewController.m
//  Channely
//
//  Created by Beng on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuViewController.h"
#import "ChanUser.h"

enum {
    kLogin,
    kSignup
};

static const int USERNAME_MIN_LEN = 1;
static const int PASSWORD_MIN_LEN = 1;

@interface ChanMenuViewController ()

@property UINavigationController *channelNavigationController;

@property UIPopoverController *channelPopover;

@end

@implementation ChanMenuViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login to Channely"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Login", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.tag = kLogin;
    [alert show];
}

- (IBAction)signup:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sign Up for Channely"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Sign Up", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.tag = kSignup;
    [alert show];
}

- (IBAction)channels:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    _channelNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ChanChannelNavigationController"];
    
    _channelPopover = [[UIPopoverController alloc]initWithContentViewController:_channelNavigationController];
 
    [_channelPopover presentPopoverFromRect:_channelButton.frame inView:[[self view]superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Cancel button clicked
    if (buttonIndex == 0){
        return;
    }
    
    NSString *username = [alertView textFieldAtIndex:0].text;
    NSString *password = [alertView textFieldAtIndex:1].text;
    
    if (alertView.tag == kLogin) {
        [ChanUser getAccessTokenWithUsername:username password:password withCompletion:^(ChanUser *user, NSError *error) {
            
        }];
    } else if (alertView.tag == kSignup) {
        [ChanUser createUserWithUsername:username password:password withCompletion:^(ChanUser *user, NSError *error) {
            
        }];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *username = [alertView textFieldAtIndex:0].text;
    NSString *password = [alertView textFieldAtIndex:1].text;
    
    return username.length >= USERNAME_MIN_LEN && password.length >= PASSWORD_MIN_LEN;
}

@end
