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

@interface ChanMenuUserViewController ()

@end

@implementation ChanMenuUserViewController

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
    
    if ([ChanUser loggedInUser] == nil){
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([ChanUser loggedInUser] == nil)
        [self switchToAnonUserViewController];
}


- (void) switchToAnonUserViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanMenuAnonUserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChanMenuAnonUserViewController"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    [viewControllers removeObject:self];
    [viewControllers addObject:userViewController];
    [self.navigationController setViewControllers:viewControllers];
}


- (IBAction)update:(id)sender {
    if (![_updateStatus isAnimating]){
        if ([[_username text]length] == 0){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Update"
                                                             message:@"Invalid username"
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
            return;
        }
        
        NSString *password = [_password text];
        if ([password length] == 0)
            password = nil;
        
        [[ChanUser loggedInUser]updateUser:[_username text] password:password withCompletion:^(ChanUser *user, NSError *error) {
            [_updateStatus stopAnimating];
            [_username setText:[[ChanUser loggedInUser]name]];
        }];
        
        [_updateStatus startAnimating];
    }
}

- (IBAction)logout:(id)sender {
    [ChanUser logout];
    [self switchToAnonUserViewController];
}
@end
