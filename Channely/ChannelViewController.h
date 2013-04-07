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

@class ChanChannel;

@interface ChannelViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AttachPickerControllerDelegate, ChanCreateEventViewControllerDelegate, UIPopoverControllerDelegate>

@property ChanChannel *channel;

@property ChannelPostTableViewController *postTableViewController;

@property NSMutableArray *posts;

@property (weak, nonatomic) IBOutlet UITextView *textInput;

@property (weak, nonatomic) IBOutlet UIButton *attachButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendPostIndicator;

- (IBAction)attach:(id)sender;

- (IBAction)sendPost:(id)sender;

- (void)pickImage:(id)sender;

- (void)takePhoto:(id)sender;

- (void)pickVideo:(id)sender;

-(void) createEventWithEventName:(NSString*)eventName startDate:(NSDate*)startDate endDate:(NSDate*)endDate description:(NSString*)description lat:(double) lat lon:(double) lon;

@end
