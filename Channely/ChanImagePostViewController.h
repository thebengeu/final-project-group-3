//
//  ChanImagePostViewController.h
//  Channely
//
//  Created by k on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "ChanPostViewController.h"

@interface ChanImagePostViewController : ChanPostViewController

@property UIImage *image;

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;

@property (weak, nonatomic) IBOutlet BButton *postButton;

- (IBAction)submit:(id)sender;
@end
