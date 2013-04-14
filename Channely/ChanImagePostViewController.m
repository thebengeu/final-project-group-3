//
//  ChanImagePostViewController.m
//  Channely
//
//  Created by k on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImagePostViewController.h"

@interface ChanImagePostViewController ()

@end

@implementation ChanImagePostViewController

@synthesize channel = _channel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *name;
    if ([ChanUser loggedInUser] == nil)
        name = [ChanAnonUser name];
    else
        name = [[ChanUser loggedInUser]name];
    
    _username.text = name;
    _imageView.image = _image;
}

- (IBAction)submit:(id)sender {
    ChanImagePostViewController *me = self;
    [[me status]startAnimating];
    
    [_channel addImagePostWithContent:[_text text] username:[_username text] image:_image withCompletion:^(ChanImagePost *imagePost, NSError *error) {
        [[me status]stopAnimating];
        [me dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
