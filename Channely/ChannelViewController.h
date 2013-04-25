//
//  ChannelViewController.h
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanAnnotationViewController.h"
#import "ChanCreateEventViewController.h"
#import "ChanCollectionViewController.h"
#import "ChanPostViewController.h"
#import "ChannelViewControllerDelegate.h"

@class ChanChannel;
@class ChanCollectionViewController;

@interface ChannelViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChanCreateEventViewControllerDelegate, UIPopoverControllerDelegate,
ChannelViewControllerDelegate, ChanAnnotationViewControllerDelegate, ChanPostViewControllerDelegate>

//  Data
@property ChanChannel *channel;

//  UI Components
@property (strong, nonatomic) IBOutlet UIView *contentContainer;
@property ChanCollectionViewController *collectionViewController;
@property (weak, nonatomic) IBOutlet UIButton *attachButton;

//  Event Creation Delegate
- (void)createEventWithEventName:(NSString *)eventName startDate:(NSDate *)startDate endDate:(NSDate *)endDate description:(NSString *)description location:(CLLocationCoordinate2D)location;

// ChannelViewControllerDelegate Methods
- (void)launchVideoSegue;
- (void)launchTextPostSegue;
- (void)launchImagePostSegue:(UIImage *)image;
- (void)launchCameraForImage;
- (void)launchImagePicker:(CGRect)frame;
- (void)launchAnnotationForImagePost:(UIImage *)image;

@end
