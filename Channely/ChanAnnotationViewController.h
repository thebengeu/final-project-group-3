//
//  ChanAnnotationViewController.h
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanChannel.h"
#import "AnnotationUIView.h"

@protocol ChanAnnotationViewControllerDelegate

- (void) didFinishAnnotation:(UIImage*)image;

@end

@interface ChanAnnotationViewController : UIViewController

@property (strong, nonatomic) IBOutlet AnnotationUIView *annotationView;

@property UIImage *image;

@property id<ChanAnnotationViewControllerDelegate> delegate;

- (IBAction)redColor:(id)sender;
- (IBAction)greenColor:(id)sender;
- (IBAction)blueColor:(id)sender;

- (IBAction)done:(id)sender;
- (IBAction)clear:(id)sender;

@end
