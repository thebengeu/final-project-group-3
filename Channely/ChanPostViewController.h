//
//  ChanPostViewController.h
//  Channely
//
//  Created by k on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanChannel.h"
#import "ChanUser.h"
#import "ChanAnonUser.h"

@protocol ChanPostViewControllerDelegate

- (void) didPost:(ChanChannel*)channel;

@end

@interface ChanPostViewController : UIViewController

@property ChanChannel *channel;
@property UITapGestureRecognizer *tapBehindRecognizer;
@property id<ChanPostViewControllerDelegate> delegate;

- (void) hideKeyboard;

@end
