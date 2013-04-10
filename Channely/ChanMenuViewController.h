//
//  ChanMenuViewController.h
//  Channely
//
//  Created by Beng on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanMenuViewController : UIViewController

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)channels:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *channelButton;
@end
