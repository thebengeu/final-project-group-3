//
//  ChanCollectionViewCell.m
//  Channely
//
//  Created by Cedric on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTextCell.h"
#import "Constants.h"
#import "ChanPost.h"

@implementation ChanTextCell

- (NSString *)backgroundImageName
{
    return @"textbar";
}

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    self.textView.text = post.content;
    self.titleView.text = post.username;

    // Disable user interactions for the textview, so that touch events go to the cell
    [self.textView setUserInteractionEnabled:NO];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    CGSize sizeWithFont = [post.content sizeWithFont:[UIFont fontWithName:kTextCellContentFontName size:kTextCellContentFontSize]
                                   constrainedToSize:CGSizeMake(kTextCellContentMaxWidth, kTextCellContentMaxHeight)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    return sizeWithFont.height + kTextCellContentVerticalMargins;
}

@end
