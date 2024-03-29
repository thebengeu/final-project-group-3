//
//  ChanCollectionCell.m
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChanAbstractCell.h"
#import "Constants.h"

@implementation ChanAbstractCell

- (void)setPost:(id)post
{
    _post = post;
    [self setupBackgroundImage];
}

+ (CGFloat)getHeightForPost:(ChanPost *)post
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:kOverrideClassMessage, NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setupBackgroundImage
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(-3, 3);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    UIImage *cellImg = [[UIImage imageNamed:self.backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(kCellBackgroundImageHeight, 0, 0, 0)];
    self.backgroundView = [[UIImageView alloc] initWithImage:cellImg];
}

@end
