//
//  ChanMenuUserViewController.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface ChanMenuUserViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet BButton *editChannelButton;
@property (weak, nonatomic) IBOutlet BButton *logoutButton;
@property (weak, nonatomic) IBOutlet BButton *updateButton;

- (IBAction)update:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *updateStatus;

- (IBAction)logout:(id)sender;

@end
