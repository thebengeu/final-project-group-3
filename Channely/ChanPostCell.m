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

@synthesize post = _post;

-(void)setPost:(ChanPost *)post{
    _post = post;
    [[self timeView]setText:[[post createdAt]description]];
    [[self usernameView]setText:post.username];
}

-(ChanPost*)post{
    return _post;
}

@end
