//
//  ChanSearchResultEventCell.h
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanSearchResultEventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *channelName;

@property (strong, nonatomic) IBOutlet UITextView *eventName;

@property (strong, nonatomic) IBOutlet UITextView *description;

@end
