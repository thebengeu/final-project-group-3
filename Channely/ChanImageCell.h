//
//  ChanTextCollectionCell.h
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanAbstractCell.h"
#import "ChanPost.h"
#import "ChanImagePost.h"

@interface ChanImageCell : ChanAbstractCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelView;

@end
