//
//  ChanVideoPostCell.m
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoPostCell.h"

@interface ChanVideoPostCell ()
- (void) setPost:(ChanPost *)post;

@end

@implementation ChanVideoPostCell
- (void) setPost:(ChanPost *)post {
    [super setPost:post];
    
    ChanVideoPost *videoPost = (ChanVideoPost *)post;
    NSString *recordingId = [ChanUtility fileNameFromURLString:videoPost.url];
    
    self.textContent.text = [NSString stringWithFormat:@"Placeholder for recordingId:%@", recordingId];
}



@end
