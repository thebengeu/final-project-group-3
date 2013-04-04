#import <CoreLocation/CLLocation.h>

#import "_ChanEvent.h"

@interface ChanEvent : _ChanEvent {}

+ (void)search:(CLLocationCoordinate2D)location
withinDistance:(CLLocationDistance)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block;

@end
