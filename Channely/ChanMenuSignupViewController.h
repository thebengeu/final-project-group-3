//
//  ChanMenuSignupViewController.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanMenuSignupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;

- (IBAction)submit:(id)sender;

@end
