//
//  AnnotationUIViewController.h
//  AnnotationDemo
//
//  Created by k on 5/4/13.
//  Copyright (c) 2013 k. All rights reserved.
//

/*
 *  Init: [[AnnotationUIView alloc]initWithFrame:"Target frame"];
 *  Set color (default black) and size (default 4.0) by property
 *  Get screenshot by screenshot method
 */

#import <UIKit/UIKit.h>

@interface AnnotationUIView : UIImageView

@property UIColor *markerColor;

@property CGFloat markerSize;

-(UIImage*)screenshot;

@end
