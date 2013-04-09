//
//  ChanImagePostCell.h
//  Channely
//
//  Created by k on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostCell.h"

@interface ChanImagePostCell : ChanPostCell

@property (weak, nonatomic) IBOutlet UIImageView *imageContent;

@property (weak, nonatomic) IBOutlet UITextView *textContent;

@property (weak, nonatomic) IBOutlet UIButton *drawButton;

@end
