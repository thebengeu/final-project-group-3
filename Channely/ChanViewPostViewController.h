//
//  ChanViewPostViewController.h
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPost.h"

@interface ChanViewPostViewController : UIViewController

@property UITapGestureRecognizer *tapBehindRecognizer;

@property ChanPost *post;

@end