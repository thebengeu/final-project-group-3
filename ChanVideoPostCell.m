//
//  ChanVideoPostCell.m
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPostCell.h"

@interface ChanVideoPostCell ()
// Redefinitions.
@property (readwrite, strong) NSString *serverURL;

- (void) setPost:(ChanPost *)post;

@end

@implementation ChanVideoPostCell
// Redefinitions.
@synthesize serverURL;

- (void) setPost:(ChanPost *)post {
    [super setPost:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    serverURL = videoPost.url;
    
    self.textContent.text = [NSString stringWithFormat:@"Placeholder for video at:%@", serverURL];
}

@end
