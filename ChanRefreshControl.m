//
//  ChanRefreshControl.m
//  Channely
//
//  Created by Beng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRefreshControl.h"
#import "UIColor+Channely.h"

@implementation ChanRefreshControl

- (id)init
{
    self = [super init];
    if (self) {
        self.tintColor = [UIColor channelyGray];
    }
    return self;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    
    NSMutableAttributedString *mutableAttributedTitle = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
    [mutableAttributedTitle addAttribute:NSForegroundColorAttributeName
                            value:[UIColor channelyGray]
                            range:NSMakeRange(0, attributedTitle.length)];
    [super setAttributedTitle:mutableAttributedTitle];
}

@end
