//
//  ChanViewTextPostViewController.h
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanViewPostViewController.h"

@interface ChanViewTextPostViewController : ChanViewPostViewController

- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *username;

@property (strong, nonatomic) IBOutlet UITextView *date;

@property (strong, nonatomic) IBOutlet UITextView *text;

@end
