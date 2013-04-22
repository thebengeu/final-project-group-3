//
//  ChanViewImagePostViewController.m
//  Channely
//
//  Created by k on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanViewImagePostViewController.h"
#import "ChanImagePost.h"
#import "SVProgressHUD.h"
#import "ChanUser.h"

@interface ChanViewImagePostViewController ()

@end

@implementation ChanViewImagePostViewController



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
    
    [_image setImageWithURL:[NSURL URLWithString:[(ChanImagePost*)[self post] url]]];
    
    // Set delete button
    [_deleteButton setType:BButtonTypeInverse];
    if ([[ChanUser loggedInUser].id compare:[[self post] creator].id] == NSOrderedSame && [ChanUser loggedInUser].id != nil)
        [_deleteButton setHidden:NO];
    else {
        [_deleteButton removeFromSuperview];
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deletePost:(id)sender {
    [(ChanImagePost*)[self post] deleteWithCompletion:^(ChanImagePost *textPost, NSError *error) {
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

- (IBAction)annotate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self delegate]launchAnnotationForImagePost:[_image image]];
    }];
}

@end
