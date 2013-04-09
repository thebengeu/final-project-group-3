//
//  ChanVideoThumbnailPostCell.m
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoThumbnailPostCell.h"
#import "ChanVideoThumbnailPost.h"

@implementation ChanVideoThumbnailPostCell

-(void)setPost:(ChanPost *)post{
    [super setPost:post];
    [[self textContent]setText:[(ChanVideoThumbnailPost*)post url]];
//    [[self imageContent]setImageWithURL:[NSURL URLWithString:[(ChanVideoThumbnailPost*)post url]]];
//    NSLog(@"%@",[(ChanVideoThumbnailPost*)post url]);
}

@end
