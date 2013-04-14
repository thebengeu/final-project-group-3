//
//  ChannelPostTableViewController.m
//  Channely
//
//  Created by k on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelPostTableViewController.h"

static NSString *const cAnnotationSegue = @"AnnotationSegue";
static NSString *const cVideoPlayerSegue = @"videoPlayerSegue";
static NSString *const cSlideSegue = @"slidesSegue";

/*  Things to do for seguing:

 if ([segueName isEqualToString: @"AnnotationSegue"]) {
    ChanAnnotationViewController * annotationViewController = (ChanAnnotationViewController *) [segue destinationViewController];
    ChanImagePostCell *cell = (ChanImagePostCell*)[[((UIButton*)sender)superview] superview];
 
    annotationViewController.channel = [[cell post] channel];
    annotationViewController.image = [[cell imageContent]image];
 }

 
 */

@implementation ChannelPostTableViewController

@synthesize postList = _postList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString:cAnnotationSegue]) {
        ChanAnnotationViewController * annotationViewController = (ChanAnnotationViewController *) [segue destinationViewController];
        ChanImagePostCell *cell = (ChanImagePostCell*)[[((UIButton*)sender)superview] superview];
        
        annotationViewController.channel = [[cell post] channel];
        annotationViewController.image = [[cell imageContent]image];
    } else if ([segueName isEqualToString:cVideoPlayerSegue]) {
        ChanVideoPlayerViewController *vpvc = (ChanVideoPlayerViewController *)segue.destinationViewController;
        ChanVideoPostCell *cell = (ChanVideoPostCell *)((UIButton *)sender).superview.superview;
        
        [vpvc setServerURL:cell.serverURL forChannel:cell.post.channel];
    } else if ([segueName isEqualToString:cSlideSegue]) {
        ChanSlidesViewController *slidesViewController = (ChanSlidesViewController *)segue.destinationViewController;
        ChanSlidesPostCell *cell = (ChanSlidesPostCell *)((UIButton *)sender).superview.superview;
        
        slidesViewController.channel = cell.post.channel;
        slidesViewController.post = (ChanSlidesPost *)cell.post;
    }
}

- (void)setPostList:(NSMutableArray *)postList
{
    _postList = postList;
    [[self tableView]reloadData];
    NSInteger tableRows = [[self tableView] numberOfRowsInSection:0];
    if (tableRows > 0)
        [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:tableRows-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];

}

- (NSArray*)postList
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
    Class postClass = [post class];
    
    //  Match according to post type
    if (postClass == [ChanTextPost class]){
       cell = [tableView dequeueReusableCellWithIdentifier:@"ChanTextPostCell"];
        if(cell == nil) {
            cell = [[ChanTextPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanTextPostCell"];
        }
    } else if (postClass == [ChanImagePost class]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanImagePostCell"];
        if(cell == nil) {
            cell = [[ChanImagePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanImagePostCell"];
        }
    } else if (postClass == [ChanVideoPost class]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanVideoPostCell"];
        if(cell == nil) {
            cell = [[ChanVideoPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanVideoPostCell"];
        }
    } else if (postClass == [ChanVideoThumbnailPost class]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanVideoThumbnailPost"];
        if(cell == nil) {
            cell = [[ChanVideoThumbnailPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanVideoThumbnailPost"];
        }
    } else if (postClass == [ChanSlidesPost class]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChanSlidesPostCell"];
        if(cell == nil) {
            cell = [[ChanSlidesPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChanSlidesPostCell"];
        }
    }
    
    [cell setPost:post];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [_postList objectAtIndex:[indexPath row]];
    Class postClass = [post class];
    
    if (postClass == [ChanTextPost class]){
        //CGSize size = [[post content] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(75, [tableView frame].size.width)];
        return 100;
        //return size.height + 25;
    }
    else if (postClass == [ChanImagePost class])
        return 233;
    else if (postClass == [ChanVideoPost class])
        return 233;
    else if (postClass == [ChanVideoThumbnailPost class])
        return 0;
    else if (postClass == [ChanSlidesPost class])
        return 233;
    return 0;
}


@end
