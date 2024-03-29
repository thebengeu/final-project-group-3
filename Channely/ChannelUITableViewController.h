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

//  For map to receive updates
@protocol DiscoverUITableViewControllerDelegate <NSObject, DiscoverUITableCellDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CLLocationCoordinate2D)location;

@end


@interface ChannelUITableViewController : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style channelList:(NSMutableArray *)channelList;

- (void)selectMapAnnotationForChannel:(id)cell;

@property (nonatomic) NSArray *channelList;

//  Set to view map
@property id<DiscoverUITableViewControllerDelegate> delegate;

@end
