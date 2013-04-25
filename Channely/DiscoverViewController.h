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

@interface DiscoverViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, DiscoverUITableViewControllerDelegate>

//  Locations for map
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D location;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//  Table
@property (weak, nonatomic) IBOutlet UIView *channelListContainer;
@property ChannelUITableViewController *channelTableViewController;
@property NSUInteger currentSelectedIndex;

//  Current list of channels listed
@property NSArray *channelList;

@end
