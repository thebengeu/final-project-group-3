//
//  AttachPickerViewController.h
//  Channely
//
//  Created by k on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttachPickerControllerDelegate <NSObject>
- (void)pickImage:(id)sender;
- (void)takePhoto:(id)sender;
- (void)pickVideo:(id)sender;
@end

@interface AttachPickerViewController : UIViewController

- (IBAction)pickImage:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)pickVideo:(id)sender;

@property id<AttachPickerControllerDelegate> delegate;

@end
