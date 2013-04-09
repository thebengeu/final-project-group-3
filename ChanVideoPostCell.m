//
//  ChanVideoPostCell.m
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPostCell.h"
#import "ChanVideoPost.h"

@implementation ChanVideoPostCell

-(void)setPostContent:(ChanPost *)post{
    [super setPostContent:post];
    [[self textContent]setText:[(ChanVideoPost*)post url]];
}

@end
