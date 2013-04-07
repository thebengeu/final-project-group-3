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

@interface ChanCreateEventViewController : UIViewController <UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UITextViewField *descriptionTextViewField;

- (IBAction)startDateEditingBegin:(id)sender;
- (IBAction)endDateEditingBegin:(id)sender;
- (IBAction)createEvent:(id)sender;

@property NSDate *startDate;
@property NSDate *endDate;
@property CLLocationCoordinate2D chosenCoordinate;

@end
