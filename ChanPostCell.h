//
//  ChanPostCell.h
//  Channely
//
//  Created by k on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPost.h"

@interface ChanPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *timeView;

@property (weak, nonatomic) IBOutlet UITextView *usernameView;

-(void)setPostContent: (ChanPost*)post;

@end
