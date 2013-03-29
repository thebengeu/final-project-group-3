//
//  DiscoverViewController.m
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ChannelUITableViewCell.h"
#import "ChannelUITableViewController.h"
#import "ChannelAnnotation.h"
#import "LocationAnnotation.h"
#import "ChannelViewController.h"
#import "ChanEventStore.h"
#import "ChanEvent.h"
#import "ChanChannel.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController{
    Boolean firstUpdate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    _mapView.delegate = self;
    _channelTableViewController.delegate = self;
    
    //  Force first update
    firstUpdate = false;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"DiscoverChannelContainerSeque"]) {
        ChannelUITableViewController * childViewController = (ChannelUITableViewController *) [segue destinationViewController];
        _channelTableViewController = childViewController;
    }
    if ([[segue identifier] isEqualToString:@"ChannelSegue"])
    {
        ChannelViewController *vc = (ChannelViewController *)[segue destinationViewController];
        [vc setChannelName:[[sender channelNameTextView]text]];
    } 
    
}

-(void) populateTableWithChannel{
    [_channelTableViewController setChannelList:_channelList];
}

-(void) populateMapWithChannelAnnotation{
    [_mapView removeAnnotations:[_mapView annotations]];
    
    //  Channel nearby
    for (int i = 0; i < [_channelList count]; i++){
        NSObject *channel = [_channelList objectAtIndex:i];
        
        CLLocationCoordinate2D channelLocation = CLLocationCoordinate2DMake([[channel valueForKey:@"Lat"] doubleValue], [[channel valueForKey:@"Lon"] doubleValue]);
        
        ChannelAnnotation *annotation = [[ChannelAnnotation alloc] initWithChannelName:[channel valueForKey:@"ChannelName"] eventName:[channel valueForKey:@"EventName"] coordinate:channelLocation];
        [annotation setChannelId:[NSNumber numberWithInt:i]];
        [_mapView addAnnotation:annotation];
    }
    
    //  Self location
    LocationAnnotation *locationAnnotation = [[LocationAnnotation alloc]initWithCoordinate:_location];
    [_mapView addAnnotation:locationAnnotation];
    
    [self zoomToFitMapAnnotations:_mapView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _location = newLocation.coordinate;
    NSLog(@"Geo found at %f %f", _location.latitude, _location.longitude);
    
    // TODO: introduce threshold for requerying?
    if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude ||
        newLocation.coordinate.longitude != oldLocation.coordinate.longitude) {
        _channelList = [[NSMutableArray alloc] init];
        
        // search for nearby events within 1 km
        [[ChanEventStore sharedStore] search:_location withinDistance:1000.0 withCompletion:^(NSArray *events, NSError *error) {
            for (ChanEvent *event in events) {
                [_channelList addObject: @{
                 @"ChannelName": event.channel.name,
                 @"EventName": event.name,
                 @"Description": event.details,
                 @"Lat": event.latitude,
                 @"Lon": event.longitude,
                 @"ChannelId": event.channel.id}];
            }
            
            [self populateTableWithChannel];
            [self populateMapWithChannelAnnotation];
        }];
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
    
    for(ChannelAnnotation* annotation in mapView.annotations)
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





- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    static NSString *locationIdentifier = @"MyLocation";
    static NSString *channelIdentifier = @"ChannelLocation";
    MKPinAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[LocationAnnotation class]]) {
        annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:locationIdentifier];
        if (annotationView == nil) 
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationIdentifier];
        else
            annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorGreen;
    } else if ([annotation isKindOfClass:[ChannelAnnotation class]]){
        annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:channelIdentifier];
        if (annotationView == nil)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:channelIdentifier];
        else
            annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorRed;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;

    return annotationView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelUITableViewCell *cell = (ChannelUITableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *selectedChannelId = [cell channelId];
    NSArray *annotations = [_mapView annotations];
    for (int i = 0; i < [annotations count]; i++){
        if ( [[annotations objectAtIndex:i] class] != [ChannelAnnotation class])
            continue;
        ChannelAnnotation *annotation = [annotations objectAtIndex:i];
        if ([[annotation channelId] compare:selectedChannelId] == NSOrderedSame){
            [_mapView selectAnnotation:annotation animated:YES];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([[view annotation] class] != [ChannelAnnotation class]){
        [[_channelTableViewController tableView] deselectRowAtIndexPath:[[_channelTableViewController tableView] indexPathForSelectedRow] animated:NO];
        return;
    }
    
    ChannelAnnotation *annotation = [view annotation];
    NSNumber *selectedChannelId = [annotation channelId];
    for (int i = 0; i < [_channelList count]; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        NSDictionary *channel = [_channelList objectAtIndex:i];
        if ([selectedChannelId intValue] == [[channel valueForKey:@"ChannelId"]intValue]){
            [[_channelTableViewController tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
}


-(void) enterChannel: (id) cell
{
    [self performSegueWithIdentifier:@"ChannelSegue" sender:cell];
}


@end
