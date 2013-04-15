//
//  ChanAnnotationViewController.m
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAnnotationViewController.h"
#import "ChanAnonUser.h"

@interface ChanAnnotationViewController ()

@end

@implementation ChanAnnotationViewController

@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [_annotationView setOriginalImage:_image];
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    [_annotationView setOriginalImage:image];
}

- (UIImage*) image{
    return [_annotationView image];
}


- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self delegate]didFinishAnnotation:[_annotationView image]];
    }];
}


- (IBAction)redColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor redColor]];
}

- (IBAction)greenColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor greenColor]];
}

- (IBAction)blueColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor blueColor]];
}

- (IBAction)clear:(id)sender {
    [_annotationView clear];
}

- (IBAction)cancel:(id)sender {
    [_annotationView setImage:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
