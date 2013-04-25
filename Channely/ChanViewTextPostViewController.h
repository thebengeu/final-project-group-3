//
//  ChanViewTextPostViewController.h
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanViewPostViewController.h"

@class BButton;

@interface ChanViewTextPostViewController : ChanViewPostViewController

//  UI Components
@property (strong, nonatomic) IBOutlet UITextView *username;
@property (strong, nonatomic) IBOutlet UITextView *date;
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet BButton *deleteButton;

//  UI Actions
- (IBAction)deletePost:(id)sender;
- (IBAction)close:(id)sender;

@end
