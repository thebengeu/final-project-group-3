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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPost:(ChanPost *)post {
    [super setPost:post];
    ChanSlidesPost *chanSlidesPost = (ChanSlidesPost *)post;
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:urlDescriptor];
    NSArray *slides = [[chanSlidesPost.slides allObjects] sortedArrayUsingDescriptors:descriptors];
    
    if (slides.count) {
        ChanSlidePost* firstSlide = [slides objectAtIndex:0];
        [self.imageView setImageWithURL:[NSURL URLWithString:firstSlide.url]];
    }

    [self.labelView setText:[post content]];
}

+ (CGFloat) getHeightForPost:(ChanPost *)post
{
    // TODO: dynamic height
    return 240.0f;
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
