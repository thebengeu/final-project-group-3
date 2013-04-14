//
//  ChanCollectionView.m
//  Channely
//
//  Created by Beng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanCollectionView.h"
#import "ChanAbstractCell.h"

@implementation ChanCollectionView

// Uses private API to fix UICollectionView bug with very tall cells
// Ref: http://stackoverflow.com/questions/14254222/large-uicollectionviewcell-stopped-being-displayed-when-scrolling
- (CGRect)_visibleBounds {
    CGRect rect = super._visibleBounds;
    rect.size.height = MAX(self.maxCellHeight, self.bounds.size.height);
    return rect;
}

@end
