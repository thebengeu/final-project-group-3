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

@end



@implementation ChanCreateEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _annotationCreated = NO;
        _startDate = [NSDate networkDate];
        _endDate = [[NSDate networkDate]dateByAddingTimeInterval:60*60];
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
    if (_annotationCreated)
        return;
    
    _location = newLocation.coordinate;
    
       //  Self location
    SelectionAnnotation *locationAnnotation = [[SelectionAnnotation alloc]initWithCoordinate:_location];
    [_map addAnnotation:locationAnnotation];
}

- (void) selectedPoint:(UITapGestureRecognizer *)gestureRecognizer {
    CLLocationCoordinate2D coordinate = [self.map convertPoint:[gestureRecognizer locationInView:self.map] toCoordinateFromView:self.map];

    if (_selection)
        [_selection setCoordinate:coordinate];
    else {
        _selection = [[SelectionAnnotation alloc]initWithCoordinate:_location];
        [_map addAnnotation:_selection];
    }
    
    [_map setCenterCoordinate:coordinate animated:YES];
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
    [_startDateDatePicker setMinuteInterval:5];
    [_startDateDatePicker setTag:10];
    [_startDateDatePicker addTarget:self action:@selector(Result) forControlEvents:UIControlEventValueChanged];
    [_startDateDatePicker setDate:_startDate];
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
    [_endDateDatePicker setMinuteInterval:5];
    [_endDateDatePicker setTag:10];
    [_endDateDatePicker addTarget:self action:@selector(Result) forControlEvents:UIControlEventValueChanged];
    [_endDateDatePicker setDate:_endDate];
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
    
    NSLog(@"To create Event: %@ %f %f %@ %@ %@", [_eventNameTextField text], [_selection coordinate].latitude, [_selection coordinate].longitude, [_descriptionTextViewField text], [_startDate description], [_endDate description]);
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if ([popoverController isEqual:_startDatePopoverController]){
        _startDate = [_startDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _startDatePopoverController = nil;
        _startDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        [_startDateTextField setText:[dateFormat stringFromDate:_startDate]];
    } else if ([popoverController isEqual:_endDatePopoverController]){
        _endDate = [_endDateDatePicker date];
        [popoverController dismissPopoverAnimated:YES];
        _endDatePopoverController = nil;
        _endDateDatePicker = nil;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        [_endDateTextField setText:[dateFormat stringFromDate:_endDate]];

    }
}

@end
