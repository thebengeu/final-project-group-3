//
//  ChanMenuAnonUserViewController.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface ChanMenuAnonUserViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *anonUsername;
@property (weak, nonatomic) IBOutlet BButton *loginButton;
@property (weak, nonatomic) IBOutlet BButton *signupButton;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;

@end
