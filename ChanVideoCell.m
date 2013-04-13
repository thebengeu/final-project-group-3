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

static const CGFloat kThumbnailWidth = 80.0f;
static const CGFloat kThumbnailHeight = 60.0f;
static const int kThumbnailsPerRow = 3;
static const int kMaxThumbnails = 120;
static const CGFloat kHeaderHeight = 17.0f;

@implementation ChanVideoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPost:(ChanPost *)post {
    [super setPost:post];
    [self setupBackgroundImage];
    
    ChanVideoPost *videoPost = (ChanVideoPost*)post;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:NO];
    NSArray * descriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *thumbnails  = [[videoPost.thumbnails allObjects] sortedArrayUsingDescriptors:descriptors];
    
    [thumbnails enumerateObjectsUsingBlock:^(ChanVideoThumbnailPost *thumbnail, NSUInteger idx, BOOL *stop) {
        if (idx >= kMaxThumbnails) {
            *stop = YES;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
            (idx % kThumbnailsPerRow) * kThumbnailWidth,
            (kThumbnailHeight * (idx / kThumbnailsPerRow)) + kHeaderHeight,
                kThumbnailWidth,
                kThumbnailHeight)];
        [imageView setImageWithURL:[NSURL URLWithString:thumbnail.url]];
        [self.contentView addSubview:imageView];
    }];
}

+ (CGFloat) getHeightForPost:(ChanPost *)post
{
    ChanVideoPost *videoPost = (ChanVideoPost *)post;

    CGFloat min = MIN(kThumbnailHeight * ceil(videoPost.thumbnails.count / (float)kThumbnailsPerRow), kThumbnailHeight * ceil(kMaxThumbnails / (float)kThumbnailsPerRow)) + kHeaderHeight;
    
    if (min < 140.0f)
        return 140.0f;
    else
        return min;
}

- (void)setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"videobar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    self.backgroundView = [[UIImageView alloc] initWithImage:cellImg];
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
