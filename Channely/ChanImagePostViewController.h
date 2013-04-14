//
//  ChanImagePostViewController.h
//  Channely
//
//  Created by k on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPostViewController.h"

@interface ChanImagePostViewController : ChanPostViewController

@property UIImage *image;

@property (strong, nonatomic) IBOutlet UILabel *username;

@property (strong, nonatomic) IBOutlet UITextView *text;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)submit:(id)sender;
@end
