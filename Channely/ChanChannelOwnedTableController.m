//
//  ChanChannelOwnedTableController.m
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanChannelOwnedTableController.h"
#import "ChanUser.h"
#import "ChanChannelOwnedTableCell.h"
#import "ChanChannel.h"
#import "ChanChannelCreateUpdateViewController.h"
#import "ChanDetailViewController.h"

@interface ChanChannelOwnedTableController ()

@property NSMutableArray *channels;

@end



@implementation ChanChannelOwnedTableController

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
    
    [[self navigationItem] setTitle:@"Channels"];
    
    
    [[ChanUser loggedInUser]getOwnedChannels:^(NSArray *channels, NSError *error){
        _channels = [NSMutableArray arrayWithArray:channels];
        [[self tableView]reloadData];
        [[self tableView]setHidden:NO];
    }];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"CreateChannelSegue"]) {
        ChanChannelCreateUpdateViewController *channelCreateUpdateViewController = (ChanChannelCreateUpdateViewController *) [segue destinationViewController];
        channelCreateUpdateViewController.isUpdateChannel = NO;
    } else if ([segueName isEqualToString: @"UpdateChannelSegue"]){
        ChanChannelCreateUpdateViewController *channelCreateUpdateViewController = (ChanChannelCreateUpdateViewController *) [segue destinationViewController];
        channelCreateUpdateViewController.isUpdateChannel = YES;
        channelCreateUpdateViewController.channel = [(ChanChannelOwnedTableCell*)[[sender superview]superview] channel];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChanChannelOwnedTableCell";
    ChanChannelOwnedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell){
        cell = [[ChanChannelOwnedTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanChannelOwnedTableCell"];
    }
    ChanChannel *channel = [_channels objectAtIndex:[indexPath row]];
    [cell.channelName setText: [channel name]];
    if ([[channel hashTag]length] > 0)
        [cell.hashtag setText: [NSString stringWithFormat:@"#%@", [channel hashTag]]];
    else
        [cell.hashtag setText:@""];
    cell.channel = [_channels objectAtIndex:[indexPath row]];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    ChanDetailViewController *detail = [[rootVC childViewControllers]objectAtIndex:0];
    
    [detail startChannel:[_channels objectAtIndex:row]];
}

@end
