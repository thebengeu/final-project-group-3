#import "ChanEvent.h"
#import "ChanAPIEndpoints.h"

@interface ChanEvent ()

// Private interface goes here.

@end


@implementation ChanEvent

+ (void)search:(CLLocationCoordinate2D)location
withinDistance:(CLLocationDistance)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithDouble:location.latitude], @"latitude",
                            [NSNumber numberWithDouble:location.longitude], @"longitude",
                            [NSNumber numberWithDouble:maxDistance], @"maxDistance",
                            nil];
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_EVENTS_SEARCH parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
