//
//  ChanTwitterCell.m
//  Channely
//
//  Created by Beng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTwitterCell.h"

@implementation ChanTwitterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPost:(ChanPost*)post{
    [super setPost:post];
    self.textView.text = post.content;
    self.titleView.text = post.username;
    
    [self setupBackgroundImage];
}

- (void) setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"textbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    self.backgroundView = [[UIImageView alloc] initWithImage:cellImg];
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
