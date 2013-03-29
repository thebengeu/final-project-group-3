//
//  ChanTextPostCell.h
//  Channely
//
//  Created by k on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostCell.h"
#import "ChanTextPost.h"

@interface ChanTextPostCell : ChanPostCell

@property (weak, nonatomic) IBOutlet UITextView *textContent;

-(void)setPostContent: (ChanPost*)post;

@end
