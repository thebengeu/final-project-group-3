//
//  ChanCreateEventViewController.m
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanCreateEventViewController.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "AHAlertView.h"
#import "BButton.h"
#import "SSTextView.h"
#import "SelectionAnnotation.h"

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
    
    _startDate = [NSDate date];
    _endDate = [[NSDate date]dateByAddingTimeInterval:60 * 60];
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedPoint:)];
    _map.delegate = self;
    [_map addGestureRecognizer:tap];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: kDateFormat];
    [_startDateTextField setTitle:[dateFormat stringFromDate:_startDate] forState:UIControlStateNormal];
    [_endDateTextField setTitle:[dateFormat stringFromDate:_endDate] forState:UIControlStateNormal];
    
    // Setup create button style
    [_createButton setType:BButtonTypeChan];
    
    // Setup placeholder for SSTextView
    _descriptionTextViewField.placeholder = kCreateEventDescriptionPlaceholder;
    _descriptionTextViewField.layer.borderWidth = 1.0f;
    _descriptionTextViewField.layer.borderColor = [[UIColor channelyGray] CGColor];
    
    // Setup border for map view
    _map.layer.borderColor = [UIColor channelyGray].CGColor;
    _map.layer.borderWidth = 1.0;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (_annotationCreated == YES) return;
    
    _location = newLocation.coordinate;
    
    //  Self location
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    _selection.eventName = _eventNameTextField.text;
    [_map addAnnotation:_selection];
    [self zoomToFitMapAnnotations:_map];
    _annotationCreated = YES;
}

- (void)selectedPoint:(UITapGestureRecognizer *)gestureRecognizer
{
    CLLocationCoordinate2D coordinate = [self.map convertPoint:[gestureRecognizer locationInView:self.map] toCoordinateFromView:self.map];
    
    [self updateAnnotation:coordinate];
}

- (void)updateAnnotation:(CLLocationCoordinate2D)coordinate
{
    [_map removeAnnotations:[_map annotations]];
    _location = coordinate;
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    _selection.eventName = _eventNameTextField.text;
    [_map addAnnotation:_selection];
    
    
    [_map setCenterCoordinate:coordinate animated:YES];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [_map selectAnnotation:_selection animated:YES];
    });
}

- (void)updateAnnotation
{
    _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    _selection.eventName = _eventNameTextField.text;
    [_map addAnnotation:_selection];
    
    [_map selectAnnotation:_selection animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[SelectionAnnotation class]]) {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kSelectedMapAnnotationTitle];
        if (annotationView == nil) annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kSelectedMapAnnotationTitle];
        else annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (IBAction)startDateEditingBegin:(id)sender
{
    if (_startDatePopoverController != nil) return;
    
    UIViewController *popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    _startDateDatePicker = [[UIDatePicker alloc]init]; //Date picker
    _startDateDatePicker.frame = CGRectMake(0, 44, 320, 216);
    _startDateDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_startDateDatePicker setDate:_startDate animated:NO];
    [popoverView addSubview:_startDateDatePicker];
    
    popoverContent.view = popoverView;
    _startDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    _startDatePopoverController.delegate = self;
    
    [_startDatePopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [_startDatePopoverController presentPopoverFromRect:_startDateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)endDateEditingBegin:(id)sender
{
    if (_endDatePopoverController != nil) return;
    
    UIViewController *popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor blackColor];
    
    _endDateDatePicker = [[UIDatePicker alloc]init]; //Date picker
    _endDateDatePicker.frame = CGRectMake(0, 44, 320, 216);
    _endDateDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_endDateDatePicker setDate:_endDate animated:NO];
    [popoverView addSubview:_endDateDatePicker];
    
    popoverContent.view = popoverView;
    _endDatePopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    _endDatePopoverController.delegate = self;
    
    [_endDatePopoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [_endDatePopoverController presentPopoverFromRect:_endDateTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)createEvent:(id)sender
{
    if ([[_eventNameTextField text]length] == 0) {
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:kCreateEventAlertTitle message:kCreateEventInvalidTitleMessage];
        __weak AHAlertView *weakA = alert;
        [alert setCancelButtonTitle:kOkButtonTitle block:^{
            weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
        }];
        [alert show];
        return;
    }
    
    if ([_startDate compare:_endDate] == NSOrderedDescending) {
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:kCreateEventAlertTitle message:kCreateEventInvalidDateMessage];
        __weak AHAlertView *weakA = alert;
        [alert setCancelButtonTitle:kOkButtonTitle block:^{
            weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
        }];
        [alert show];
        return;
    }
    
    [_delegate createEventWithEventName:[_eventNameTextField text] startDate:_startDate endDate:_endDate description:[_descriptionTextViewField text] location:_location];
}

- (IBAction)eventNameChanged:(id)sender
{
    if (sender == _eventNameTextField) [self updateAnnotation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if ([popoverController isEqual:_startDatePopoverController]) {
        _startDate = [_startDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _startDatePopoverController = nil;
        _startDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kDateFormat];
        [_startDateTextField setTitle:[dateFormat stringFromDate:_startDate] forState:UIControlStateNormal];
    } else if ([popoverController isEqual:_endDatePopoverController]) {
        _endDate = [_endDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _endDatePopoverController = nil;
        _endDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kDateFormat];
        [_endDateTextField setTitle:[dateFormat stringFromDate:_endDate] forState:UIControlStateNormal];
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView
{
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (SelectionAnnotation *annotation in _map.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
    region.span.latitudeDelta = MAX(region.span.latitudeDelta, 0.07);
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
    region.span.latitudeDelta = MAX(region.span.longitudeDelta, 0.07);
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

@end
