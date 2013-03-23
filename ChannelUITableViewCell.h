//
//  ChannelUITableViewCell.h
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *enterEventButton;

@property (weak, nonatomic) IBOutlet UITextView *description;

@property (weak, nonatomic) IBOutlet UITextView *channelName;

@property (weak, nonatomic) IBOutlet UITextView *eventName;

@end
