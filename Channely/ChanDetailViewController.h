//
//  ChanDetailViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"
#import "ChanSearchBarViewController.h"

@interface ChanDetailViewController : UIViewController <UITabBarDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonPressed:(id)sender;

- (void)startChannel:(ChanChannel*)channel;

@end
