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

@interface ChanAnnotationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property AnnotationUIView *annotationView;

@property UIImage *image;
@property ChanChannel *channel;

- (IBAction)redColor:(id)sender;
- (IBAction)greenColor:(id)sender;
- (IBAction)blueColor:(id)sender;


@property (weak, nonatomic) IBOutlet UITextView *textContent;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)clear:(id)sender;

@end
