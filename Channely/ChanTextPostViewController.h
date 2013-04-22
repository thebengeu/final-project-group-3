//
//  ChanTextPostViewController.h
//  Channely
//
//  Created by k on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "ChanPostViewController.h"

@interface ChanTextPostViewController : ChanPostViewController

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextView *text;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *status;
@property (weak, nonatomic) IBOutlet BButton *postButton;
@property (weak, nonatomic) IBOutlet BButton *cancelButton;

- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
