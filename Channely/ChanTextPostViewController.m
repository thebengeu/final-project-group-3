//
//  ChanTextPostViewController.m
//  Channely
//
//  Created by k on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTextPostViewController.h"

@interface ChanTextPostViewController ()

@end

@implementation ChanTextPostViewController

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
    
}

- (IBAction)submit:(id)sender {
    if ([[_text text]length] > 0){
        ChanTextPostViewController *me = self;
        [[me status]startAnimating];
        [_channel addTextPostWithContent:[_text text] username:[_username text] withCompletion:^(ChanTextPost *textPost, NSError *error) {
            [[me status]stopAnimating];
            [me dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}


@end
