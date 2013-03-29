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

-(void)setPostContent:(ChanPost *)post{
    [super setPostContent:post];
    [[self textContent]setText:[(ChanImagePost*)post content]];
    [[self imageContent]setImageWithURL:[NSURL URLWithString:[(ChanImagePost*)post url]]];
    NSLog(@"%@",[(ChanImagePost*)post url]);
}

@end
