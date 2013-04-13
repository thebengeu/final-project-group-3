//
//  ChanCollectionViewCell.m
//  Channely
//
//  Created by Cedric on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTextCell.h"

@implementation ChanTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPostContent:(ChanPost*)post{
    [super setPostContent:post];
    self.textView.text = post.content;
    self.titleView.text = post.username;
//    NSLog(@"POST: %@ \n", post.content);
}

+ (CGFloat) getHeightForPost:(ChanPost *)post
{
    return 190.0f;
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
