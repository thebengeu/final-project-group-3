//
//  ChanCollectionView.h
//  Channely
//
//  Created by Beng on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView ()
- (CGRect)_visibleBounds;
@end

@interface ChanCollectionView : UICollectionView

@property CGFloat maxCellHeight;

@end
