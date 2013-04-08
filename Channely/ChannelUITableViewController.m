//
//  ChannelUITableViewController.m
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelUITableViewController.h"
#import "ChannelUITableViewCell.h"
#import "ChannelViewController.h"
#import "ChanEvent.h"
#import "ChanChannel.h"

@interface ChannelUITableViewController ()

@end

@implementation ChannelUITableViewController

@synthesize channelList = _channelList;

- (id)initWithStyle:(UITableViewStyle)style :(NSMutableArray*)channelList
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setChannelList:channelList];
    }
    return self;
}

- (void)setChannelList: (NSMutableArray*)channels{
    _channelList = channels;
    [[self tableView]reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ChannelUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
    if(cell == nil) {
        cell = [[ChannelUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChannelCell"];
    }
    
    [[cell channelNameTextView]setText: event.channel.name];
    [[cell eventNameTextView]setText: event.name];
    [[cell descriptionTextView]setText: event.details];
    cell.event = event;
    [cell setDelegate:(id<DiscoverUITableCellDelegate>)self];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self delegate]tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void) selectMapAnnotationForChannel: (id) cell
{
    [[self delegate] selectMapAnnotationForChannel: cell];
}




@end
