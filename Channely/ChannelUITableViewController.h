//
//  ChannelUITableViewController.h
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ChannelUITableViewCell.h"

@protocol DiscoverUITableViewControllerDelegate <NSObject, DiscoverUITableCellDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CLLocationCoordinate2D)location;

@end


@interface ChannelUITableViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style :(NSMutableArray*)channelList;

- (void) selectMapAnnotationForChannel: (id)cell;

@property (nonatomic) NSArray *channelList;

@property id<DiscoverUITableViewControllerDelegate> delegate;

@end
