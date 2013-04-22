//
//  ChanImagePostViewController.m
//  Channely
//
//  Created by k on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImagePostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+normalizedOrientation.h"

@interface ChanImagePostViewController ()

@end

@implementation ChanImagePostViewController

@synthesize channel = _channel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Setup button styles
    [_postButton setType:BButtonTypeChan];
    [_cancelButton setType:BButtonTypeInverse];
    
    NSString *name;
    if ([ChanUser loggedInUser] == nil)
        name = [ChanAnonUser name];
    else
        name = [[ChanUser loggedInUser]name];
    
    _username.text = name;
    _imageView.image = _image;
    [_imageView layer].borderColor = [UIColor whiteColor].CGColor;
    [_imageView layer].borderWidth = 2.0f;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_text becomeFirstResponder];
}

- (IBAction)submit:(id)sender {
    ChanImagePostViewController *me = self;
    [[me status]startAnimating];
    [self hideKeyboard];
    [_channel addImagePostWithContent:[_text text] username:[_username text] image:[_image normalizedImage] withCompletion:^(ChanImagePost *imagePost, NSError *error) {
        [[me status]stopAnimating];
        
        if (error == nil)
            [me dismissViewControllerAnimated:YES completion:^{
                [[me delegate]didPost:[me channel]];
            }];
        else
            [super showErrorDialog];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
