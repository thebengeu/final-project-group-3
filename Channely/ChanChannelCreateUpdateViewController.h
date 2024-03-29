//
//  ChanChannelCreateUpdateViewController.h
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;
@class BButton;

@interface ChanChannelCreateUpdateViewController : UIViewController <UIAlertViewDelegate>

//  Data
@property BOOL isUpdateChannel;
@property ChanChannel *channel;

//  UI Components
@property (strong, nonatomic) IBOutlet BButton *createUpdateButton;
@property (strong, nonatomic) IBOutlet BButton *deleteButton;
@property (strong, nonatomic) IBOutlet UITextField *channelName;
@property (strong, nonatomic) IBOutlet UITextField *hashtag;

//  UI Actions
- (IBAction)createOrUpdate:(id)sender;
- (IBAction)deleteChannel:(id)sender;

@end
