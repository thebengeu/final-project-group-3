//
//  ChanImagePostCell.m
//  Channely
//
//  Created by k on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanImagePostCell.h"
#import "ChanImagePost.h"

@implementation ChanImagePostCell

-(void)setPost:(ChanPost *)post{
    [super setPost:post];
    [[self textContent]setText:[(ChanImagePost*)post content]];
    [[self imageContent]setImageWithURL:[NSURL URLWithString:[(ChanImagePost*)post url]]];
}

@end
