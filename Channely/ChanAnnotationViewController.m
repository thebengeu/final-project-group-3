//
//  ChanAnnotationViewController.m
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAnnotationViewController.h"
#import "ChanAnonUser.h"
#import "ChanChannel.h"
#import "AnnotationUIView.h"
#import "BButton.h"

@implementation ChanAnnotationViewController

@synthesize image = _image;

- (void)viewDidLoad
{
    // Setup button styles
    [_clearButton setType:BButtonTypeGray];
    [_redButton setType:BButtonTypeDanger];
    [_blueButton setType:BButtonTypePrimary];
    [_greenButton setType:BButtonTypeSuccess];
    
    [self addTickTo:_redButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_annotationView setOriginalImage:_image];
    [_annotationView setMarkerColor:[BButton colorForButtonType:BButtonTypeDanger]];
    
    //  Bar items
    NSMutableArray *rightBarItems = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [rightBarItems addObject:doneButton];
    
    self.navigationItem.rightBarButtonItems = rightBarItems;
    self.navigationItem.title = @"Annotate";
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [_annotationView setOriginalImage:image];
}

- (UIImage *)image
{
    return [_annotationView image];
}

- (IBAction)done:(id)sender
{
    [[self delegate]didFinishAnnotation:[_annotationView image]];
}

- (void)removeTicks
{
    [_redButton setImage:nil forState:UIControlStateNormal];
    [_greenButton setImage:nil forState:UIControlStateNormal];
    [_blueButton setImage:nil forState:UIControlStateNormal];
}

- (void)addTickTo:(BButton *)button
{
    UIImage *tick = [UIImage imageNamed:@"tick"];
    [button setImage:tick forState:UIControlStateNormal];
}

/*
 
 Palette functions
 
 */

- (IBAction)redColor:(id)sender
{
    [_annotationView setMarkerColor:[BButton colorForButtonType:BButtonTypeDanger]];
    [self removeTicks];
    [self addTickTo:_redButton];
}

- (IBAction)greenColor:(id)sender
{
    [_annotationView setMarkerColor:[BButton colorForButtonType:BButtonTypeSuccess]];
    [self removeTicks];
    [self addTickTo:_greenButton];
}

- (IBAction)blueColor:(id)sender
{
    [_annotationView setMarkerColor:[BButton colorForButtonType:BButtonTypePrimary]];
    [self removeTicks];
    [self addTickTo:_blueButton];
}

- (IBAction)clear:(id)sender
{
    [_annotationView clear];
}

- (IBAction)undo:(id)sender
{
    [_annotationView undo];
}

- (IBAction)redo:(id)sender
{
    [_annotationView redo];
}

@end
