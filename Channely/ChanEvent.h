#import "_ChanEvent.h"

/**
 `ChanEvent` wraps API and persistence operations for Channely events.
 */
@interface ChanEvent : _ChanEvent {}

/**
 Search for events with given parameters. Any parameters that are nil will not be part of the search.
 
 @param name The substring to match against event names.
 @param latitude The latitude of point from which to search for events.
 @param longitude The longitude of point from which to search for events.
 @param maxDistance The maximum distance from point to search for events.
 @param occurDateTime The date/time when the event is occurring, i.e. falling within the start and end time of the event.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an NSArray of the searched for events and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)    search:(NSString *)name
          latitude:(NSNumber *)latitude
         longitude:(NSNumber *)longitude
    withinDistance:(NSNumber *)maxDistance
     occurDateTime:(NSDate *)occurDateTime
    withCompletion:(void (^)(NSArray *events, NSError *error))block;

@end
