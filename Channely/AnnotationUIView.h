//
//  AnnotationUIViewController.h
//  AnnotationDemo
//
//  Created by k on 5/4/13.
//  Copyright (c) 2013 k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationUIView : UIImageView

//  Current marker attributes
@property UIColor *markerColor;
@property CGFloat markerSize;

//  Original Image, replaces current image with image
@property UIImage *originalImage;

//  Methods for user actions
- (void)clear;
- (void)undo;
- (void)redo;

@end
