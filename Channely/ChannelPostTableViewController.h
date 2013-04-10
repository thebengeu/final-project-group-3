//
//  ChannelPostTableViewController.h
//  Channely
//
//  Created by k on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanTextPostCell.h"
#import "ChanImagePostCell.h"
#import "ChanVideoPostCell.h"
#import "ChanVideoThumbnailPostCell.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"
#import "ChanAnnotationViewController.h"
#import "ChanVideoPlayerViewController.h"

@interface ChannelPostTableViewController : UITableViewController

@property NSMutableArray *postList;

@end
