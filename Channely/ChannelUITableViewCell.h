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

- (void)selectMapAnnotationForChannel:(id)cell;

@end

@interface ChannelUITableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *channelNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *distanceTextView;
@property (weak, nonatomic) IBOutlet UITextView *startDateTimeTextView;
@property (weak, nonatomic) IBOutlet UITextView *endDateTimeTextView;

@property (weak, nonatomic) ChanEvent *event;
@property (strong, nonatomic) id<DiscoverUITableCellDelegate> delegate;

- (IBAction)locationButtonTapped:(id)sender;

@end
