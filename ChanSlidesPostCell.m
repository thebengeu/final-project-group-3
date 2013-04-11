//
//  ChanSlidesPostCell.m
//  Channely
//
//  Created by Beng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanSlidesPostCell.h"
#import "ChanSlidesPost.h"

@implementation ChanSlidesPostCell


-(void)setPost:(ChanPost *)post{
    [super setPost:post];
    [[self textContent]setText:[(ChanSlidesPost*)post url]];
}

@end
