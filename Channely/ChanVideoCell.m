//
//  ChanVideoCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoCell.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"
#import "Constants.h"

@implementation ChanVideoCell

- (NSString *)backgroundImageName
{
    return @"videobar";
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *thumbnails  = [[videoPost.thumbnails allObjects] sortedArrayUsingDescriptors:descriptors];
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [thumbnails enumerateObjectsUsingBlock:^(ChanVideoThumbnailPost *thumbnail, NSUInteger idx, BOOL *stop) {
        if (idx >= kVideoCellMaxThumbnails) {
            *stop = YES;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                               (idx % kVideoCellThumbnailsPerRow) * kVideoCellThumbnailWidth,
                                                                               (kVideoCellThumbnailHeight * (idx / kVideoCellThumbnailsPerRow)) + kVideoCellHeaderHeight,
                                                                               kVideoCellThumbnailWidth - kVideoCellThumbnailRightMargin,
                                                                               kVideoCellThumbnailHeight - kVideoCellThumbnailBottomMargin)];
        [imageView setImageWithURL:[NSURL URLWithString:thumbnail.url]];
        [self.contentView addSubview:imageView];
    }];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    
    CGFloat min = MIN(kVideoCellThumbnailHeight * ceil(videoPost.thumbnails.count / (float)kVideoCellThumbnailsPerRow),
                      kVideoCellThumbnailHeight * ceil(kVideoCellMaxThumbnails / (float)kVideoCellThumbnailsPerRow)) + kVideoCellHeaderHeight;
    
    if (min < 140.0f) return 140.0f;
    else return min;
}

@end
