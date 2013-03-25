//
//  DiscoverViewController.h
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ChannelUITableViewController.h"

@interface DiscoverViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, ChannelUITableViewControllerDelegate>

@property CLLocationManager *locationManager;

@property CLLocationCoordinate2D location;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *channelListContainer;

@property NSMutableArray* channelList;

@property ChannelUITableViewController *channelTableViewController;

@property int currentSelectedIndex;

- (void) populateMapWithChannelAnnotation;

- (void) populateTableWithChannel;

//- (void) scrollMapToLocation: (CGFloat)lat : (CGFloat)lon;

//- (void) scrollTableToEvent: (NSIndexPath*)index;


@end
