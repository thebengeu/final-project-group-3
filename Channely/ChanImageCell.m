//
//  ChanTextCollectionCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImageCell.h"
#import "Constants.h"

@implementation ChanImageCell

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    [self.imageView setImageWithURL:[NSURL URLWithString:[(ChanImagePost *)post url]]];
    [self.labelView setText:[post content]];
    [self setupBackgroundImage];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    ChanImagePost *imagePost = (ChanImagePost *)post;
    return imagePost.thumbHeight + kImageCellThumbnailVerticalMargins;
}

- (void)setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"imagebar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    self.backgroundView = [[UIImageView alloc] initWithImage:cellImg];
}

@end
