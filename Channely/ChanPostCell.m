//
//  ChanPostCell.m
//  Channely
//
//  Created by k on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostCell.h"
#import "ChanUser.h"

@implementation ChanPostCell

-(void)setPostContent: (ChanPost*)post{
    [[self timeView]setText:[[post createdAt]description]];
    [[self usernameView]setText:post.username];
}

@end
