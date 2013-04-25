//
//  ChanPostViewController.h
//  Channely
//
//  Created by k on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;

//  Delegate to handle didPost
@protocol ChanPostViewControllerDelegate

- (void)didPost:(ChanChannel *)channel;

@end

@interface ChanPostViewController : UIViewController

@property ChanChannel *channel;
@property UITapGestureRecognizer *tapBehindRecognizer;
@property id<ChanPostViewControllerDelegate> delegate;

//  Methods available for subclasses
- (void)hideKeyboard;
- (void)showErrorDialog;

@end
