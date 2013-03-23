//
//  DiscoverViewController.m
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ChannelUITableViewCell.h"

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

    //  Force first update
    firstUpdate = false;
}

- (void) populateFakeChannelList{
    _channelList = [[NSMutableArray alloc]init];
   
    for (int i = 0; i < 10; i++){
        NSMutableDictionary *channel = [[NSMutableDictionary alloc]init];
        [channel setValue:[NSString stringWithFormat:@"Channel %d", i] forKey:@"ChannelName"];
        [channel setValue:[NSString stringWithFormat:@"Event %d", i] forKey:@"EventName"];
        [channel setValue:[NSString stringWithFormat:@"Description %d", i] forKey:@"Description"];
        [channel setValue:[NSString stringWithFormat:@"Channel %d", i] forKey:@"ChannelName"];
        
        NSNumber *channelLat = [[NSNumber alloc]initWithDouble:_lat + (arc4random() % 1000)/1000.0];
        NSNumber *channelLon = [[NSNumber alloc]initWithDouble:_lon + (arc4random() % 1000)/1000.0];
        [channel setValue:channelLat forKey:@"Lat"];
        [channel setValue:channelLon forKey:@"Lon"];
        [_channelList addObject: channel];
    }
}

-(void) populateTableWithChannel{
    for (int i = 0; i < [_channelList count]; i++){
        NSMutableDictionary *channel = [_channelList objectAtIndex:i];
        ChannelUITableViewCell *channelCell = (ChannelUITableViewCell *)[_channelTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [[channelCell channelName] setText:[channel valueForKey:@"ChannelName"]];
        [[channelCell eventName] setText:[channel valueForKey:@"EventName"]];
        [[channelCell description] setText:[channel valueForKey:@"Description"]];
    }
    [_channelTable reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _lat = newLocation.coordinate.latitude;
    _lon = newLocation.coordinate.longitude;
    NSLog(@"Geo found at %f %f", _lat, _lon);
    
    //  Add fake events for the first time
    if (firstUpdate == false){
        [self populateFakeChannelList];
        firstUpdate = true;
        [self populateTableWithChannel];
    }
}

@end
