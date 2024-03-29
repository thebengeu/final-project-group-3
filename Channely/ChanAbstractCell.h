//
//  ChanCollectionCell.h
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanPost;

// This is the abstract class for the collection cells used in the ChanCollectionViewController
// This should not be instantiated; use one of the child classes

@interface ChanAbstractCell : UICollectionViewCell

@property (readonly) NSString *backgroundImageName;
@property (strong, nonatomic) ChanPost *post;

+ (CGFloat)getHeightForPost:(ChanPost *)post;

@end
