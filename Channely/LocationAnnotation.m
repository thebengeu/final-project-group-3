//
//  LocationAnnotation.m
//  Channely
//
//  Created by k on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    if ((self = [super init])) {
        _coordinate = coord;
    }
    return self;
}

- (NSString *)title {
    return @"You are here";
}

@end
