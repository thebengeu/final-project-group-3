//
//  ChannelAnnotation.m
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelAnnotation.h"

@implementation ChannelAnnotation

@synthesize coordinate = _coordinate;

- (id)initWithChannelName:(NSString *)channelName eventName:(NSString *)eventName coordinate:(CLLocationCoordinate2D)coord
{
    if ((self = [super init])) {
        _channelName = channelName;
        _eventName = eventName;
        _coordinate = coord;
    }
    return self;
}

- (NSString *)title
{
    return _channelName;
}

- (NSString *)subtitle
{
    return _eventName;
}

@end
