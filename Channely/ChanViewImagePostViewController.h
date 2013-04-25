//
//  ChanViewImagePostViewController.h
//  Channely
//
//  Created by k on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanViewPostViewController.h"

@class BButton;
@protocol ChannelViewControllerDelegate;

@interface ChanViewImagePostViewController : ChanViewPostViewController

//  UI Components
@property (strong, nonatomic) IBOutlet UITextView *username;
@property (strong, nonatomic) IBOutlet UITextView *date;
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet BButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *image;

//  Delegate for annotation
@property id<ChannelViewControllerDelegate> delegate;

//  UI Actions
- (IBAction)deletePost:(id)sender;
- (IBAction)annotate:(id)sender;
- (IBAction)close:(id)sender;

@end
