//
//  ChanLocationPickerViewController.h
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"

@interface ChanLocationPickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
