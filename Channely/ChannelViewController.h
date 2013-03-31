//
//  ChannelViewController.h
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelPostTableViewController.h"

@class ChanChannel;

@interface ChannelViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property ChanChannel *channel;

@property ChannelPostTableViewController *postTableViewController;

@property NSMutableArray *posts;

@property (weak, nonatomic) IBOutlet UITextView *textInput;

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;

- (IBAction)pickImage:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)sendPost:(id)sender;

@end
