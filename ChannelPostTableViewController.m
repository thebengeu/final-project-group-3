//
//  ChannelPostTableViewController.m
//  Channely
//
//  Created by k on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelPostTableViewController.h"
#import "ChanTextPostCell.h"
#import "ChanImagePostCell.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"

@implementation ChannelPostTableViewController

@synthesize postList = _postList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)setPostList:(NSMutableArray *)postList
{
    _postList = postList;
    [[self tableView]reloadData];
}

- (NSMutableArray*)postList
{
    return _postList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _postList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [_postList objectAtIndex:[indexPath row]];
    ChanPostCell *cell;
    
    //  Match according to post type
    if ([[[post class]description] compare:[ChanTextPost description]] == NSOrderedSame){
       cell = [tableView dequeueReusableCellWithIdentifier:@"ChanTextPostCell"];
        if(cell == nil) {
            cell = [[ChanTextPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanTextPostCell"];
        }
    } else if ([[[post class]description] compare:[ChanImagePost description]] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanImagePostCell"];
        if(cell == nil) {
            cell = [[ChanImagePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanImagePostCell"];
        }
    }
    
    [cell setPostContent:post];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [_postList objectAtIndex:[indexPath row]];
    
    if ([[[post class]description] compare:[ChanTextPost description]] == NSOrderedSame){
        //CGSize size = [[post content] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(75, [tableView frame].size.width)];
        return 100;
        //return size.height + 25;
    }
    else if ([[[post class]description] compare:[ChanImagePost description]] == NSOrderedSame)
        return 233;
    return 0;
}

@end
