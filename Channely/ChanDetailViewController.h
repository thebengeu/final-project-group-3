//
//  ChanDetailViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;

@interface ChanDetailViewController : UIViewController <UITabBarDelegate, UIPopoverControllerDelegate, UISearchBarDelegate>

//  UI Components
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

//  Pushes a channel view into navigation controller
- (void)startChannel:(ChanChannel *)channel;

@end
