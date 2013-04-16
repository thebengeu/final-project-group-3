//
//  ChanTwitterCell.h
//  Channely
//
//  Created by Beng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAbstractCell.h"

@interface ChanTwitterCell : ChanAbstractCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end
