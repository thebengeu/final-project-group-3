//
//  ChanCreateEventViewController.m
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanCreateEventViewController.h"
#import "SelectionAnnotation.h"
#import "ios-ntp.h"

@interface ChanCreateEventViewController ()

@property CLLocationCoordinate2D location;

@property SelectionAnnotation *selection;

@property Boolean annotationCreated;

@property UIPopoverController *startDatePopoverController;

@property UIPopoverController *endDatePopoverController;

@property UIDatePicker *startDateDatePicker;

@property UIDatePicker *endDateDatePicker;

@property CLLocationManager *locationManager;

@end



@implementation ChanCreateEventViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _annotationCreated = NO;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _startDate = [NSDate networkDate];
    _endDate = [[NSDate networkDate]dateByAddingTimeInterval:60*60];
    
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action: @selector(selectedPoint:)];
    _map.delegate = self;
    [_map addGestureRecognizer:tap];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    [_startDateTextField setTitle:[dateFormat stringFromDate:_startDate] forState:UIControlStateNormal];
    [_endDateTextField setTitle:[dateFormat stringFromDate:_endDate] forState:UIControlStateNormal];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (_annotationCreated == YES)
        return;
    
    _location = newLocation.coordinate;
    
    //  Self location
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    [_map addAnnotation:_selection];
    [self zoomToFitMapAnnotations:_map];
    _annotationCreated = YES;
}

- (void) selectedPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CLLocationCoordinate2D coordinate = [self.map convertPoint:[gestureRecognizer locationInView:self.map] toCoordinateFromView:self.map];

    [_map removeAnnotations:[_map annotations]];
    _location = coordinate;
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    [_map addAnnotation:_selection];
    
    [_map setCenterCoordinate:coordinate animated:YES];
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {NSLog(@"asd");
    static NSString *selectionIdentifier = @"Selection";
    MKPinAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[SelectionAnnotation class]]) {
        annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:selectionIdentifier];
        if (annotationView == nil)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:selectionIdentifier];
        else
            annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
    }
    
    return annotationView;
}





- (IBAction)startDateEditingBegin:(id)sender {
    if (_startDatePopoverController != nil)
        return;
    
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    _startDateDatePicker = [[UIDatePicker alloc]init];//Date picker
    _startDateDatePicker.frame=CGRectMake(0,44,320, 216);
    _startDateDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_startDateDatePicker setDate:_startDate animated:NO];
    [popoverView addSubview: _startDateDatePicker];
    
    popoverContent.view = popoverView;
    _startDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    _startDatePopoverController.delegate=self;
 
    [_startDatePopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [_startDatePopoverController presentPopoverFromRect:_startDateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)endDateEditingBegin:(id)sender {
    if (_endDatePopoverController != nil)
        return;
    
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    _endDateDatePicker = [[UIDatePicker alloc]init];//Date picker
    _endDateDatePicker.frame=CGRectMake(0,44,320, 216);
    _endDateDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_endDateDatePicker setDate:_endDate animated:NO];
    [popoverView addSubview: _endDateDatePicker];
    
    popoverContent.view = popoverView;
    _endDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    _endDatePopoverController.delegate=self;
    
    [_endDatePopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [_endDatePopoverController presentPopoverFromRect:_endDateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)createEvent:(id)sender {
    if ([[_eventNameTextField text]length] == 0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Create Event"
                                                          message:@"Please enter an event name."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    if ([_startDate compare:_endDate] == NSOrderedDescending){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Create Event"
                                                          message:@"Start date is later than end date."
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    
    [_delegate createEventWithEventName:[_eventNameTextField text] startDate:_startDate endDate:_endDate description:[_descriptionTextViewField text] location:_location];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if ([popoverController isEqual:_startDatePopoverController]){
        _startDate = [_startDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _startDatePopoverController = nil;
        _startDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        [_startDateTextField setTitle:[dateFormat stringFromDate:_startDate] forState:UIControlStateNormal];
    } else if ([popoverController isEqual:_endDatePopoverController]){
        _endDate = [_endDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _endDatePopoverController = nil;
        _endDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        [_endDateTextField setTitle:[dateFormat stringFromDate:_endDate] forState:UIControlStateNormal];

    }
}






-(void)zoomToFitMapAnnotations:(MKMapView*)mapView{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(SelectionAnnotation* annotation in _map.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}


@end
