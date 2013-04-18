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
    
    //  Bar items
    NSMutableArray *rightBarItems = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [rightBarItems addObject:doneButton];
    
    self.navigationItem.rightBarButtonItems = rightBarItems;
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
    [[self delegate]didFinishAnnotation:[_annotationView image]];
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


@end
