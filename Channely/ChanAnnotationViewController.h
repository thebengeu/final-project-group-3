//
//  ChanAnnotationViewController.h
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnotationUIView;
@class BButton;

@protocol ChanAnnotationViewControllerDelegate

- (void)didFinishAnnotation:(UIImage *)image;

@end

@interface ChanAnnotationViewController : UIViewController

//  UI Components
@property (strong, nonatomic) IBOutlet AnnotationUIView *annotationView;
@property UIImage *image;
@property (weak, nonatomic) IBOutlet BButton *clearButton;
@property (weak, nonatomic) IBOutlet BButton *redoButton;
@property (weak, nonatomic) IBOutlet BButton *undoButton;
@property (weak, nonatomic) IBOutlet BButton *greenButton;
@property (weak, nonatomic) IBOutlet BButton *blueButton;
@property (weak, nonatomic) IBOutlet BButton *redButton;

//  Delegate for didFinishAnnotation
@property id<ChanAnnotationViewControllerDelegate> delegate;

//  Palette actions
- (IBAction)redColor:(id)sender;
- (IBAction)greenColor:(id)sender;
- (IBAction)blueColor:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;


@end
