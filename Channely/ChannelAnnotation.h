//
//  ChannelAnnotation.h
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ChannelAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) NSString *channelName;

@property (nonatomic, readonly) NSString *eventName;

@property (nonatomic) NSString *channelID;

@property (nonatomic) NSString *eventID;

- (id)initWithChannelName:(NSString*)channelName eventName:(NSString*)eventName coordinate:(CLLocationCoordinate2D)coord;

@end