//
//  DiscoverViewController.h
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DiscoverViewController : UIViewController <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

@property double lat;

@property double lon;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *channelTable;

@property NSMutableArray* channelList;

- (void) initMap;

- (void) populateMapWithEventMarker;

- (void) populateTableWithChannel;

- (void) scrollMapToLocation: (CGFloat)lat : (CGFloat)lon;

- (void) scrollTableToEvent: (NSIndexPath*)index;

@end
