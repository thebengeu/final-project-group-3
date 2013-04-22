//
//  ChanCollectionViewCell.m
//  Channely
//
//  Created by Cedric on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTextCell.h"
#import "Constants.h"

@implementation ChanTextCell

- (void)setPost:(ChanPost *)post
{
    [super setPost:post];
    self.textView.text = post.content;
    self.titleView.text = post.username;
    
    [self setupBackgroundImage];
    
    // Disable user interactions for the textview, so that touch events go to the cell
    [self.textView setUserInteractionEnabled:NO];
}

- (void)setupBackgroundImage
{
    [super setupBackgroundImage];
    UIImage *cellImg = [[UIImage imageNamed:@"textbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    self.backgroundView = [[UIImageView alloc] initWithImage:cellImg];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    CGSize sizeWithFont = [post.content sizeWithFont:[UIFont fontWithName:kTextCellContentFontName size:kTextCellContentFontSize]
                                   constrainedToSize:CGSizeMake(kTextCellContentMaxWidth, kTextCellContentMaxHeight)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    return sizeWithFont.height + kTextCellContentVerticalMargins;
}

@end
