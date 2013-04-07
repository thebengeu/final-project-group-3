//
//  ChanCreateEventViewController.h
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UITextViewField.h"

@protocol ChanCreateEventViewControllerDelegate

-(void) createEventWithEventName:(NSString*)eventName startDate:(NSDate*)startDate endDate:(NSDate*)endDate description:(NSString*)description lat:(double)lat lon:(double)lon;

@end

@interface ChanCreateEventViewController : UIViewController <UIPopoverControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *endDateTextField;
@property (weak, nonatomic) IBOutlet UITextViewField *descriptionTextViewField;

- (IBAction)startDateEditingBegin:(id)sender;
- (IBAction)endDateEditingBegin:(id)sender;
- (IBAction)createEvent:(id)sender;

@property NSDate *startDate;
@property NSDate *endDate;
@property CLLocationCoordinate2D chosenCoordinate;

@property id<ChanCreateEventViewControllerDelegate> delegate;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
