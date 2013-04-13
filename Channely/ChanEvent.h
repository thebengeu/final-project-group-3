#import <CoreLocation/CLLocation.h>

#import "_ChanEvent.h"

@interface ChanEvent : _ChanEvent {}

+ (void)search:(NSString *)name
      latitude:(NSNumber *)latitude
     longitude:(NSNumber *)longitude
withinDistance:(NSNumber *)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block;

@end
