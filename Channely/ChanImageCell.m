//
//  ChanTextCollectionCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImageCell.h"
#import "Constants.h"
#import "ChanPost.h"
#import "ChanImagePost.h"

@implementation ChanImageCell

- (NSString *)backgroundImageName
{
    return @"imagebar";
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    [self.imageView setImageWithURL:[NSURL URLWithString:[(ChanImagePost *)post url]]];
    [self.labelView setText:[post content]];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    ChanImagePost *imagePost = (ChanImagePost *)post;
    return imagePost.thumbHeight + kImageCellThumbnailVerticalMargins;
}

@end
