//
//  ChanChannelCreateUpdateViewController.h
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanChannel.h"

@interface ChanChannelCreateUpdateViewController : UIViewController

@property BOOL isUpdateChannel;

@property ChanChannel *channel;

@property (strong, nonatomic) IBOutlet UIButton *createUpdateButton;

@property (strong, nonatomic) IBOutlet UITextField *channelName;

@property (strong, nonatomic) IBOutlet UITextField *hashtag;

- (IBAction)createOrUpdate:(id)sender;
- (IBAction)enter:(id)sender;

@end
