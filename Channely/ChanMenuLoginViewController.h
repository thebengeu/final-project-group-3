//
//  ChanMenuLoginViewController.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface ChanMenuLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet BButton *submitButton;

- (IBAction)submit:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;


@end
