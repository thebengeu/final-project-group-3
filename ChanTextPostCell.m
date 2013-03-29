//
//  ChanTextPostCell.m
//  Channely
//
//  Created by k on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTextPostCell.h"
#import "ChanTextPost.h"

@implementation ChanTextPostCell

-(void)setPostContent:(ChanPost *)post{
    [super setPostContent:post];
    [[self textContent]setText:[(ChanTextPost*)post content]];
}

@end
