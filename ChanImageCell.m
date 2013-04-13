//
//  ChanTextCollectionCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImageCell.h"

@implementation ChanImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    [self.imageView setImageWithURL:[NSURL URLWithString:[(ChanImagePost*)post url]]];
    [self.labelView setText:[post content]];
    [self setupBackgroundImage];
     
}

+ (CGFloat) getHeightForPost:(ChanPost *)post
{
    // TODO: dynamic height
    return 240.0f;
}

- (void) setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"imagebar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
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
