//
//  ChanMenuUserViewController.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanMenuUserViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;

@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)update:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *updateStatus;

- (IBAction)logout:(id)sender;

@end
