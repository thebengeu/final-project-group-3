//
//  ChanMenuAnonUserViewController.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanMenuAnonUserViewController.h"
#import "ChanUser.h"
#import "ChanMenuUserViewController.h"
#import "ChanAnonUser.h"
#import "SVProgressHUD.h"

@interface ChanMenuAnonUserViewController ()

@end

@implementation ChanMenuAnonUserViewController

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

    //  If user is logged in
    if ([ChanUser loggedInUser] != nil){
        [self switchToUserViewController];
        return;
    }
    
    // Set navbar items
    [_anonUsername setText:[ChanAnonUser name]];
    [self.navigationItem setTitle: @"User Settings"];
    
    // Set button styles
    [_loginButton setType:BButtonTypeChan];
    [_signupButton setType:BButtonTypeInverse];
  
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([ChanUser loggedInUser] != nil)
        [self switchToUserViewController];
}

- (void) switchToUserViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanMenuUserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChanMenuUserViewController"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    [viewControllers removeObject:self];
    [viewControllers addObject:userViewController];
    [self.navigationController setViewControllers:viewControllers];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _anonUsername){
        if ([[textField text] length] > 0)
            [ChanAnonUser setName: [textField text]];
        else
            [textField setText: [ChanAnonUser name]];
    }
}

@end
