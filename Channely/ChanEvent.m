#import "ChanEvent.h"
#import "ChanAPIEndpoints.h"

@interface ChanEvent ()

// Private interface goes here.

@end


@implementation ChanEvent

+ (void)search:(NSString *)name
      latitude:(NSNumber *)latitude
     longitude:(NSNumber *)longitude
withinDistance:(NSNumber *)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            latitude, @"latitude",
                            longitude, @"longitude",
                            maxDistance, @"maxDistance",
                            name, @"name",
                            nil];
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_EVENTS_SEARCH parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
