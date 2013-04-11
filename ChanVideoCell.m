//
//  ChanVideoCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoCell.h"

@implementation ChanVideoCell

@synthesize serverUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPostContent:(ChanPost *)post {
    [super setPostContent:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost*)post;
    serverUrl = videoPost.url;
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
