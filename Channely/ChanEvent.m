#import "ChanEvent.h"
#import "ChanAPIEndpoints.h"

@implementation ChanEvent

+ (void)    search:(NSString *)name
          latitude:(NSNumber *)latitude
         longitude:(NSNumber *)longitude
    withinDistance:(NSNumber *)maxDistance
     occurDateTime:(NSDate *)occurDateTime
    withCompletion:(void (^)(NSArray *events, NSError *error))block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (latitude) [params setObject:latitude forKey:@"latitude"];
    if (longitude) [params setObject:longitude forKey:@"longitude"];
    if (maxDistance) [params setObject:maxDistance forKey:@"maxDistance"];
    if (name) [params setObject:name forKey:@"name"];
    if (occurDateTime) [params setObject:[NSNumber numberWithDouble:[occurDateTime timeIntervalSince1970] * 1000] forKey:@"occurDateTime"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_EVENTS_SEARCH parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
