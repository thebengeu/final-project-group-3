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

-(void)setPostContent:(ChanPost *)post {
    [self.imageView setImageWithURL:[NSURL URLWithString:[(ChanImagePost*)post url]]];
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
