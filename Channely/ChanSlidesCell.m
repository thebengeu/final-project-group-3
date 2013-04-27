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

@implementation ChanSlidesCell

+ (ChanSlidePost *)firstSlide:(ChanPost *)post
{
    ChanSlidesPost *chanSlidesPost = (ChanSlidesPost *)post;
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:urlDescriptor];
    NSArray *slides = [[chanSlidesPost.slides allObjects] sortedArrayUsingDescriptors:descriptors];
    
    return slides.count ? [slides objectAtIndex:0] : nil;
}

- (NSString *)backgroundImageName
{
    return @"slidebar";
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    
    ChanSlidePost *firstSlide = [ChanSlidesCell firstSlide:post];
    if (firstSlide) {
        [self.imageView setImageWithURL:[NSURL URLWithString:firstSlide.thumbUrl]];
    }
    
    [self.labelView setText:[post content]];
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

@end
