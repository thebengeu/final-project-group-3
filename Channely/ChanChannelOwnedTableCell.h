//
//  ChanChannelOwnedTableCell.h
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;

@interface ChanChannelOwnedTableCell : UITableViewCell

//  UI Component
@property (strong, nonatomic) IBOutlet UILabel *channelName;
@property (strong, nonatomic) IBOutlet UILabel *hashtag;

//  Data
@property ChanChannel *channel;

@end
