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
	// Setup button styles
    [_postButton setType:BButtonTypeChan];
    
    NSString *name;
    if ([ChanUser loggedInUser] == nil)
        name = [ChanAnonUser name];
    else
        name = [[ChanUser loggedInUser]name];
    
    _username.text = name;
    
    // Set background
    UIImage *backgroundImg = [[UIImage imageNamed:@"custom-dialog-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 18, 12, 18) resizingMode:UIImageResizingModeStretch];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [backgroundImg drawInRect:self.view.bounds];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_text becomeFirstResponder];
}

- (IBAction)submit:(id)sender {
    if ([[_text text]length] > 0){
        ChanTextPostViewController *me = self;
        [[me status]startAnimating];
        [self hideKeyboard];
        [_channel addTextPostWithContent:[_text text] username:[_username text] withCompletion:^(ChanTextPost *textPost, NSError *error) {
            [[me status]stopAnimating];
            
            if (error == nil)
                [me dismissViewControllerAnimated:YES completion:^{
                    [[me delegate]didPost:[me channel]];
                }];
            else
                [super showErrorDialog];
        }];
    }
}


@end
