//
//  ChanMenuLoginViewController.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuLoginViewController.h"
#import "ChanUser.h"

@interface ChanMenuLoginViewController ()

@end

@implementation ChanMenuLoginViewController

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


- (IBAction)submit:(id)sender {
    if (![_status isAnimating]){
        if ([[_username text]length] == 0 || [[_password text]length] == 0){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                             message:@"Invalid username or password"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
            return;
        }
        
        [ChanUser getAccessTokenWithUsername:[_username text] password:[_password text] withCompletion:^(ChanUser *user, NSError *error) {
            [_status stopAnimating];
            if (error != nil){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                                 message:@"Invalid username or password"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
            } else {
                [[self navigationController]popViewControllerAnimated:YES];
            }
        }];
        
        [_status startAnimating];
    }
}


@end