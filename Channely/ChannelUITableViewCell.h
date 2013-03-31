//
//  ChannelUITableViewCell.h
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanEvent;

@protocol DiscoverUITableCellDelegate <NSObject>

- (void)enterChannel: (id)cell;

@end

@interface ChannelUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *channelEnterButton;

@property (weak, nonatomic) IBOutlet UITextView *channelNameTextView;

@property (weak, nonatomic) IBOutlet UITextView *eventNameTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) ChanEvent *event;

@property (strong, nonatomic) id<DiscoverUITableCellDelegate> delegate;

- (IBAction)enterChannel:(id)sender;

@end
