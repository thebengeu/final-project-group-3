//
//  ChannelUITableViewController.h
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelUITableViewCell.h"

@protocol ChannelUITableViewControllerDelegate <NSObject, UITableCellDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ChannelUITableViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style :(NSMutableArray*)channelList;

- (void) enterChannel: (id) cell;

@property (nonatomic) NSMutableArray *channelList;

@property id<ChannelUITableViewControllerDelegate> delegate;

@end
