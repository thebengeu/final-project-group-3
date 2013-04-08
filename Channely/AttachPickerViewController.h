//
//  AttachPickerViewController.h
//  Channely
//
//  Created by k on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanVideoCaptureViewController.h"
#import "ChanChannel.h"

@protocol AttachPickerControllerDelegate <NSObject>
- (void) pickImage:(id)sender;
- (void) takePhoto:(id)sender;
- (void) pickVideo:(id)sender;
- (ChanChannel *) underlyingChannel;

@end

@interface AttachPickerViewController : UIViewController
@property id<AttachPickerControllerDelegate> delegate;

- (IBAction) pickImage:(id)sender;
- (IBAction) takePhoto:(id)sender;
- (IBAction) pickVideo:(id)sender;

@end
