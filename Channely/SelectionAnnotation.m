//
//  SelectionAnnotation.m
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SelectionAnnotation.h"

@implementation SelectionAnnotation

@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    if ((self = [super init])) {
        _coordinate = coord;
        
    }
    return self;
}

- (NSString*) title{
    return _eventName;
}

@end
