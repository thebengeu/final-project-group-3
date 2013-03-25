//
//  ChannelUITableViewCell.h
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableCellDelegate <NSObject>

- (void)enterChannel: (id)cell;

@end

@interface ChannelUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *channelEnterButton;

@property (weak, nonatomic) IBOutlet UITextView *channelNameTextView;

@property (weak, nonatomic) IBOutlet UITextView *eventNameTextView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic) NSNumber *channelId;

@property (strong, nonatomic) id<UITableCellDelegate> delegate;

- (IBAction)enterChannel:(id)sender;

@end
