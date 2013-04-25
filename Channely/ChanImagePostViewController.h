//
//  ChanImagePostViewController.h
//  Channely
//
//  Created by k on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPostViewController.h"

@class BButton;

@interface ChanImagePostViewController : ChanPostViewController

//  Image to be posted
@property UIImage *image;

//  UI Components
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;
@property (weak, nonatomic) IBOutlet BButton *postButton;
@property (weak, nonatomic) IBOutlet BButton *cancelButton;

//  UI Actions
- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
