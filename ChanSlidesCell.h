//
//  ChanSlidesCell.h
//  Channely
//
//  Created by Beng on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAbstractCell.h"

@interface ChanSlidesCell : ChanAbstractCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

-(void) setPostContent:(ChanPost*)post;

@end
