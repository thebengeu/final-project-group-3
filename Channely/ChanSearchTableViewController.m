//
//  ChanSearchTableViewController.m
//  Channely
//
//  Created by k on 12/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanSearchTableViewController.h"
#import "ChanChannel.h"
#import "ChanEvent.h"
#import "ChanSearchResultChannelCell.h"
#import "ChanSearchResultEventCell.h"
#import "ChanDetailViewController.h"

@interface ChanSearchTableViewController ()

@property NSArray *channelSearchResults;

@property NSArray *eventSearchResults;

@end

@implementation ChanSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ChanChannel search:_searchTerm withCompletion:^(NSArray *channels, NSError *error){
        _channelSearchResults = channels;
        [[self tableView]reloadData];
    }];
    
    [ChanEvent search:_searchTerm latitude:nil longitude:nil withinDistance:nil withCompletion:^(NSArray *events, NSError *error) {
        _eventSearchResults = events;
        [[self tableView]reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 && [_channelSearchResults count] > 0)
        return @"Channels";
    else if (section == 1 && [_eventSearchResults count] > 0)
        return @"Events";
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [_channelSearchResults count];
    else
        return [_eventSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if ([indexPath section] == 0){
        static NSString *CellIdentifier = @"ChannelCell";
        ChanSearchResultChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (!cell)
            cell = [[ChanSearchResultChannelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChannelCell"];
        
        ChanChannel *channel = [_channelSearchResults objectAtIndex:row];
        cell.channelName.text = [channel name];
        cell.hashtag.text = [channel hashTag];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"EventCell";
        ChanSearchResultEventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (!cell)
            cell = [[ChanSearchResultEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventCell"];

        ChanEvent *event = [_eventSearchResults objectAtIndex:row];
        ChanChannel *channel = [event channel];
        
        cell.channelName.text = [channel name];
        cell.eventName.text = [event name];
        cell.description.text = [event details];
        
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row = [indexPath row];
    
    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    ChanDetailViewController *detail = [[rootVC childViewControllers]objectAtIndex:0];
    
    if (section == 0)
        [detail startChannel:[_channelSearchResults objectAtIndex:row]];
    else
        [detail startChannel:[[_eventSearchResults objectAtIndex:row]channel]];
}

@end
