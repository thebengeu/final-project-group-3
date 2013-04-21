//
//  ChanViewImagePostViewController.h
//  Channely
//
//  Created by k on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanViewPostViewController.h"
#import "ChannelViewController.h"

@interface ChanViewImagePostViewController : ChanViewPostViewController

- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *username;

@property (strong, nonatomic) IBOutlet UITextView *date;

@property (strong, nonatomic) IBOutlet UITextView *text;

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property id<ChannelViewControllerDelegate> delegate;

- (IBAction)deletePost:(id)sender;

- (IBAction)annotate:(id)sender;

@end
