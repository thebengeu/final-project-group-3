//
//  ChanEventStore.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class ChanEvent;

@interface ChanEventStore : NSObject

+ (ChanEventStore *)sharedStore;
- (void)search:(CLLocationCoordinate2D)location
withinDistance:(CLLocationDistance)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block;

@end
