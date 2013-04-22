//
//  ChanSlidesCell.m
//  Channely
//
//  Created by Beng on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanSlidesCell.h"
#import "ChanSlidesPost.h"
#import "ChanSlidePost.h"
#import "Constants.h"

@implementation ChanSlidesCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ChanSlidePost *)firstSlide:(ChanPost *)post
{
    ChanSlidesPost *chanSlidesPost = (ChanSlidesPost *)post;
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:urlDescriptor];
    NSArray *slides = [[chanSlidesPost.slides allObjects] sortedArrayUsingDescriptors:descriptors];
    
    return slides.count ? [slides objectAtIndex:0] : nil;
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    
    ChanSlidePost *firstSlide = [ChanSlidesCell firstSlide:post];
    if (firstSlide) {
        [self.imageView setImageWithURL:[NSURL URLWithString:firstSlide.thumbUrl]];
    }
    
    [self.labelView setText:[post content]];
    [self setupBackgroundImage];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    ChanSlidePost *firstSlide = [ChanSlidesCell firstSlide:post];
    if (firstSlide) {
        return firstSlide.thumbHeight + kSlidesCellThumbnailVerticalMargins;
    } else {
        return kSlidesCellDefaultHeight;
    }
}

- (void)setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"slidebar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
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
