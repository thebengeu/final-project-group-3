//
//  ChannelViewController.h
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelPostTableViewController.h"
#import "AttachPickerViewController.h"
#import "ChanCreateEventViewController.h"
#import "ChanCollectionViewController.h"

@class ChanChannel;

@interface ChannelViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,ChanCreateEventViewControllerDelegate, UIPopoverControllerDelegate,
    ChannelViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentContainer;

@property ChanChannel *channel;

@property ChannelPostTableViewController *postTableViewController;

@property ChanCollectionViewController *collectionViewController;

@property NSArray *posts;

@property (weak, nonatomic) IBOutlet UIButton *attachButton;


- (void) createEventWithEventName:(NSString*)eventName startDate:(NSDate*)startDate endDate:(NSDate*)endDate description:(NSString*)description location:(CLLocationCoordinate2D)location;

// ChannelViewControllerDelegate Methods
- (void) launchVideoSegue;
- (void) launchTextSegue;
- (void) updateLayout;
- (void) populateChannelPost;

@end
