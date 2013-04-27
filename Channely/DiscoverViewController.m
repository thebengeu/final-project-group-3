//
//  DiscoverViewController.m
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ChannelAnnotation.h"
#import "LocationAnnotation.h"
#import "ChannelViewController.h"
#import "ChanEvent.h"
#import "ChanChannel.h"
#import "ChanRefreshControl.h"
#import "Constants.h"

static NSTimeInterval const kRotationDuration = 0.5;
static NSTimeInterval const kRotationDelay = 0.0;
static CGFloat const kLandscapeOrientationHeight = 704.0;

@interface DiscoverViewController ()
- (void)layoutForOrientation:(UIInterfaceOrientation)orientation;
- (void)layoutFromCurrentOrientation;
- (void)layoutPortrait;
- (void)layoutLandscape;

@end

@implementation DiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kDistanceFilterMetres;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    _mapView.delegate = self;
    _channelTableViewController.delegate = self;

    UIRefreshControl *refreshControl = [ChanRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshEvents) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Events"];
    self.channelTableViewController.refreshControl = refreshControl;
    
    ((UIImageView *)self.view).image = [UIImage imageNamed:@"collectionbg.png"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshEvents];
    [self layoutFromCurrentOrientation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:kDiscoverChannelContainerSegue]) {
        ChannelUITableViewController *childViewController = (ChannelUITableViewController *)[segue destinationViewController];
        _channelTableViewController = childViewController;
    } else if ([[segue identifier] isEqualToString:kChannelSegue]) {
        ChannelViewController *vc = (ChannelViewController *)[segue destinationViewController];
        vc.channel = [[sender event] channel];
    }
}

- (void)populateTableWithChannel
{
    [_channelTableViewController setChannelList:_channelList];
}

- (void)populateMapWithChannelAnnotation
{
    [_mapView removeAnnotations:[_mapView annotations]];
    
    //  Channel nearby
    for (int i = 0; i < [_channelList count]; i++) {
        ChanEvent *event = [_channelList objectAtIndex:i];
        
        CLLocationCoordinate2D channelLocation = CLLocationCoordinate2DMake(event.latitudeValue, event.longitudeValue);
        
        ChannelAnnotation *annotation = [[ChannelAnnotation alloc] initWithChannelName:event.channel.name eventName:event.name coordinate:channelLocation];
        [annotation setChannelID:event.channel.id];
        [annotation setEventID:event.id];
        [_mapView addAnnotation:annotation];
    }
    
    //  Self location
    LocationAnnotation *locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:_location];
    [_mapView addAnnotation:locationAnnotation];
    [_mapView selectAnnotation:locationAnnotation animated:YES];
    
    [self zoomToFitMapAnnotations:_mapView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [(CLLocation *)[locations lastObject] coordinate];
    NSLog(@"Geo found at %f %f", _location.latitude, _location.longitude);

    [self refreshEvents];
}

- (void)refreshEvents
{
    [ChanEvent  search:nil
              latitude:[NSNumber numberWithDouble:self.location.latitude]
             longitude:[NSNumber numberWithDouble:self.location.longitude]
        withinDistance:[NSNumber numberWithDouble:kEventsSearchRadiusInMetres]
         occurDateTime:[NSDate date]
        withCompletion:^(NSArray *events, NSError *error) {
            [self.channelTableViewController.refreshControl endRefreshing];
            
            _channelList = events;
            
            [self populateTableWithChannel];
            [self populateMapWithChannelAnnotation];
        }];
}

/*
 
 Fit the map to contain all anotations with some padding
 
 */
- (void)zoomToFitMapAnnotations:(MKMapView *)mapView
{
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (ChannelAnnotation *annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
    region.span.latitudeDelta = MAX(region.span.latitudeDelta, 0.005);
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
    region.span.latitudeDelta = MAX(region.span.longitudeDelta, 0.005);
    
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[LocationAnnotation class]]) {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kMyLocationMapAnnotation];
        if (annotationView == nil) annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kMyLocationMapAnnotation];
        else annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorGreen;
    } else if ([annotation isKindOfClass:[ChannelAnnotation class]]) {
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kChannelLocationMapAnnotation];
        if (annotationView == nil) annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kChannelLocationMapAnnotation];
        else annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelUITableViewCell *cell = (ChannelUITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kChannelSegue sender:cell];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([[view annotation] class] != [ChannelAnnotation class]) {
        [[_channelTableViewController tableView] deselectRowAtIndexPath:[[_channelTableViewController tableView] indexPathForSelectedRow] animated:NO];
        return;
    }
    
    ChannelAnnotation *annotation = [view annotation];
    NSString *selectedEventId = [annotation eventID];
    for (int i = 0; i < [_channelList count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ChanEvent *event = [_channelList objectAtIndex:i];
        if ([selectedEventId compare:event.id] == NSOrderedSame) {
            [[_channelTableViewController tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
}

- (void)selectMapAnnotationForChannel:(id)cell
{
    ChannelUITableViewCell *currCell = (ChannelUITableViewCell *)cell;
    NSString *selectedEventID = currCell.event.id;
    
    for (ChannelAnnotation *currAnnot in _mapView.annotations) {
        if ([currAnnot class] != [ChannelAnnotation class]) continue;
        if ([[currAnnot eventID] compare:selectedEventID] == NSOrderedSame) {
            [_mapView deselectAnnotation:currAnnot animated:NO];
            [_mapView selectAnnotation:currAnnot animated:YES];
            //            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
    }
}

#pragma mark Rotation Methods
- (void)layoutForOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self layoutLandscape];
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        [self layoutPortrait];
    }
}

- (void)layoutFromCurrentOrientation
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self layoutForOrientation:currentOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutForOrientation:toInterfaceOrientation];
}

- (void)layoutPortrait
{
    CGRect mapFrame = CGRectMake(0., 0., 768., 426.);
    self.mapView.frame = mapFrame;
    
    CGRect listFrame = CGRectMake(0., 426., 768., 534.);
    self.channelListContainer.frame = listFrame;
}

- (void)layoutLandscape
{
    CGRect mapFrame = CGRectMake(0., 0., 424., kLandscapeOrientationHeight);
    self.mapView.frame = mapFrame;
    
    CGRect listFrame = CGRectMake(424., 0., 600., kLandscapeOrientationHeight);
    self.channelListContainer.frame = listFrame;
}

@end
