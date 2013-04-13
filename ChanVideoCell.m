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

static const CGFloat kThumbnailWidth = 240.0f;
static const CGFloat kThumbnailHeight = 180.0f;
static const int kMaxThumbnails = 10;

@implementation ChanVideoCell

@synthesize serverUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPostContent:(ChanPost *)post {
    [super setPostContent:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost*)post;
    serverUrl = videoPost.url;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray * descriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *thumbnails  = [[videoPost.thumbnails allObjects] sortedArrayUsingDescriptors:descriptors];
    
    [thumbnails enumerateObjectsUsingBlock:^(ChanVideoThumbnailPost *thumbnail, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kThumbnailHeight * idx, kThumbnailWidth, kThumbnailHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:thumbnail.url]];
        [self.contentView addSubview:imageView];
        
        if (idx >= kMaxThumbnails - 1) {
            *stop = YES;
        }
    }];
}

+ (CGFloat) getHeightForPost:(ChanPost *)post
{
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    
    // Display max last 10 thumbnails
    return MIN(kThumbnailHeight * videoPost.thumbnails.count, kThumbnailHeight * kMaxThumbnails);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
