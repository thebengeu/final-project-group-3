//
//  ChanCollectionViewCell.h
//  Channely
//
//  Created by Cedric on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanAbstractCell.h"
#import "ChanPost.h"

@interface ChanTextCell : ChanAbstractCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

- (void) setPostContent:(ChanPost*) post;
@end
