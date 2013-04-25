//
//  ChanViewPostViewController.h
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanPost;

@interface ChanViewPostViewController : UIViewController

//  For tap to exit
@property UITapGestureRecognizer *tapBehindRecognizer;

//  Data
@property ChanPost *post;

@end