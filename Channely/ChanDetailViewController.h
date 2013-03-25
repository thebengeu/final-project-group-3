//
//  ChanDetailViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"
#import "SearchViewController.h"

@interface ChanDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *discoverSearchControl;

- (IBAction)segmentChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *container;

@property (strong) UITabBarController *homeTabController;

@end
