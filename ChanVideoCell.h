//
//  ChanVideoCell.h
//  Channely
//
//  Created by Cedric on 4/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanAbstractCell.h"
#import "ChanVideoPost.h"

@interface ChanVideoCell : ChanAbstractCell

@property (strong) NSString *serverUrl;

-(void)setPostContent:(ChanPost *)post;

@end
