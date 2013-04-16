//
//  ChannelViewController.h
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanCreateEventViewController.h"
#import "ChanCollectionViewController.h"
#import "ChanPostViewController.h"

@class ChanChannel;

@interface ChannelViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,ChanCreateEventViewControllerDelegate, UIPopoverControllerDelegate,
    ChannelViewControllerDelegate, ChanAnnotationViewControllerDelegate, ChanPostViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentContainer;

@property ChanChannel *channel;

@property ChanCollectionViewController *collectionViewController;

@property (weak, nonatomic) IBOutlet UIButton *attachButton;

- (void) createEventWithEventName:(NSString*)eventName startDate:(NSDate*)startDate endDate:(NSDate*)endDate description:(NSString*)description location:(CLLocationCoordinate2D)location;

// ChannelViewControllerDelegate Methods
- (void) launchVideoSegue;
- (void) launchTextPostSegue;
- (void) launchImagePostSegue:(UIImage *)image;
- (void) launchCameraForImage;
- (void) launchImagePicker;
- (void) launchAnnotationForImagePost:(UIImage *)image;

@end
