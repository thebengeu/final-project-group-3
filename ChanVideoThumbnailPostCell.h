//
//  ChanVideoThumbnailPostCell.h
//  Channely
//
//  Created by Beng on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostCell.h"

@interface ChanVideoThumbnailPostCell : ChanPostCell

@property (weak, nonatomic) IBOutlet UIImageView *imageContent;

@property (weak, nonatomic) IBOutlet UITextView *textContent;

@end
