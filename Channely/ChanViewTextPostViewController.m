//
//  ChanViewTextPostViewController.m
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanViewTextPostViewController.h"
#import "ChanUser.h"
#import "SVProgressHUD.h"
#import "ChanTextPost.h"

@interface ChanViewTextPostViewController ()

@end

@implementation ChanViewTextPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    
    [_text setText:[[self post] content]];
    [_date setText:[[[self post]createdAt] description]];
    [_username setText:[[self post] username]];
    
    if ([[ChanUser loggedInUser].id compare:[[self post] creator].id] == NSOrderedSame && [ChanUser loggedInUser].id != nil)
        [_deleteButton setHidden:NO];
    else
        [_deleteButton setHidden:YES];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deletePost:(id)sender {
    [(ChanTextPost*)[self post] deleteWithCompletion:^(ChanTextPost *textPost, NSError *error) {
        if (error != nil){
            [SVProgressHUD setAnimationDuration:1.5];
            [SVProgressHUD showSuccessWithStatus:@"Error occurred"];
        } else {
            [SVProgressHUD setAnimationDuration:1.5];
            [SVProgressHUD showSuccessWithStatus:@"Post deleted"];
            [self dismissViewControllerAnimated:YES completion:NO];
        }
    }];
}

@end