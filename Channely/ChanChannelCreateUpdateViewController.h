//
//  ChanChannelCreateUpdateViewController.h
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanChannel.h"
#import "BButton.h"

@interface ChanChannelCreateUpdateViewController : UIViewController

@property BOOL isUpdateChannel;

@property ChanChannel *channel;

@property (strong, nonatomic) IBOutlet BButton *createUpdateButton;

@property (strong, nonatomic) IBOutlet UITextField *channelName;
@property (strong, nonatomic) IBOutlet UITextField *hashtag;

- (IBAction)createOrUpdate:(id)sender;


@end
