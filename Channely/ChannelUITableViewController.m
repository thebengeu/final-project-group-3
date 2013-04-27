//
//  ChannelUITableViewController.m
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelUITableViewController.h"
#import "ChannelViewController.h"
#import "ChanEvent.h"
#import "ChanChannel.h"
#import "Constants.h"

@interface ChannelUITableViewController ()

@end

@implementation ChannelUITableViewController

@synthesize channelList = _channelList;

- (id)initWithStyle:(UITableViewStyle)style channelList:(NSMutableArray *)channelList
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setChannelList:channelList];
    }
    return self;
}

- (void)setChannelList:(NSMutableArray *)channels
{
    _channelList = channels;
    [[self tableView]reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_channelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChanEvent *event = [_channelList objectAtIndex:[indexPath row]];
    ChannelUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    if (cell == nil) {
        cell = [[ChannelUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventCell"];
    }
    
    cell.channelNameLabel.text = event.channel.name;
    cell.eventNameLabel.text = event.name;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:kChanDateFormat];
    cell.startDateTimeTextView.text = [dateFormat stringFromDate:event.startTime];
    cell.endDateTimeTextView.text = [dateFormat stringFromDate:event.endTime];
    
    CLLocationCoordinate2D currentLocationCoords = [self.delegate location];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocationCoords.latitude longitude:currentLocationCoords.longitude];
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:event.latitudeValue longitude:event.longitudeValue];
    CLLocationDistance distance = [eventLocation distanceFromLocation:currentLocation];
    
    // Display distances below 1 km in metres
    if (distance < kMetresPerKm) {
        [[cell distanceTextView]setText:[NSString stringWithFormat:@"%.f m", distance]];
    } else {
        [[cell distanceTextView]setText:[NSString stringWithFormat:@"%.1f km", distance / kMetresPerKm]];
    }
    
    cell.event = event;
    [cell setDelegate:(id < DiscoverUITableCellDelegate >)self];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self delegate]tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)selectMapAnnotationForChannel:(id)cell
{
    [[self delegate] selectMapAnnotationForChannel:cell];
}

@end
