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
#import "ChanVideoPostCell.h"
#import "ChanVideoThumbnailPostCell.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"

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
    NSInteger tableRows = [[self tableView] numberOfRowsInSection:0];
    if (tableRows > 0)
        [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:tableRows-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];

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
    } else if ([[[post class]description] compare:[ChanVideoPost description]] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanVideoPostCell"];
        if(cell == nil) {
            cell = [[ChanVideoPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanVideoPostCell"];
        }
    } else if ([[[post class]description] compare:[ChanVideoThumbnailPost description]] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanVideoThumbnailPost"];
        if(cell == nil) {
            cell = [[ChanVideoThumbnailPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanVideoThumbnailPost"];
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
    else if ([[[post class]description] compare:[ChanVideoPost description]] == NSOrderedSame)
        return 233;
    else if ([[[post class]description] compare:[ChanVideoThumbnailPost description]] == NSOrderedSame)
        return 0;
    return 0;
}


@end
