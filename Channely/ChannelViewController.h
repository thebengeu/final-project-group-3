//
//  ChannelViewController.h
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelPostTableViewController.h"

@interface ChannelViewController : UIViewController

@property NSString *channelName;

@property NSString *channelID;

@property ChannelPostTableViewController *postTableViewController;

@property NSMutableArray *posts;

@end
