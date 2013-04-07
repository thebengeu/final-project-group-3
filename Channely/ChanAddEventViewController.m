//
//  ChanLocationPickerViewController.m
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAddEventViewController.h"
#import "SelectionAnnotation.h"

@interface ChanLocationPickerViewController ()

@property CLLocationCoordinate2D location;

@property SelectionAnnotation *selection;

@end

@implementation ChanLocationPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action: @selector(selectedPoint)];
    
    [_map addGestureRecognizer:tap];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _location = newLocation.coordinate;
    
       //  Self location
    [_map removeAnnotations:[_map annotations]];
    LocationAnnotation *locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:_location];
    
    [_map addAnnotation:locationAnnotation];
}

- (void) selectedPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CLLocationCoordinate2D coordinate = [self.map convertPoint:[gestureRecognizer locationInView:self.map] toCoordinateFromView:self.map];
        
    [_map setCenterCoordinate:coordinate animated:YES];

    //  Remove old selection
    if (_selection)
        [_map removeAnnotation:_selection];
    
    //  Add selection annotation
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:coordinate];

}

@end
