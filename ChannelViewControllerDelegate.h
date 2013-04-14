//
//  ChannelViewControllerDelegate.h
//  Channely
//
//  Created by Cedric on 4/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChannelViewControllerDelegate <NSObject>

- (void) launchVideoSegue;

- (void) launchTextPostSegue;

- (void) launchImagePicker;

- (void) launchCameraForImage;

- (void) launchImagePostSegue:(UIImage*)image;

- (void) updateLayout;

- (void) populateChannelPost;

@end
