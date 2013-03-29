//
//  ChanEventStore.m
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanEventStore.h"
#import "ChanEvent.h"

@implementation ChanEventStore

NSString *const _API_ENDPOINT_EVENTS_SEARCH = @"/events/search";

+ (ChanEventStore *)sharedStore
{
    static ChanEventStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[ChanEventStore alloc] init];
    }
    return sharedStore;
}

- (id)init
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *channelMapping = [RKEntityMapping mappingForEntityForName:@"Channel" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [channelMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    channelMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"_id":            @"id",
     @"details":        @"details",
     @"endDateTime":    @"endTime",
     @"latitude":       @"latitude",
     @"longitude":      @"longitude",
     @"name":           @"name",
     @"startDateTime":  @"startTime"}];
    responseMapping.identificationAttributes = @[ @"id" ];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"_channel" toKeyPath:@"channel" withMapping:channelMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:_API_ENDPOINT_EVENTS_SEARCH keyPath:nil statusCodes:statusCodes];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];    
    return self;
}

- (void)search:(CLLocationCoordinate2D)location
   withinDistance:(CLLocationDistance)maxDistance
withCompletion:(void (^)(NSArray *events, NSError *error))block {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithDouble:location.latitude], @"latitude",
                            [NSNumber numberWithDouble:location.longitude], @"longitude",
                            [NSNumber numberWithDouble:maxDistance], @"maxDistance",
                            nil];
    [[RKObjectManager sharedManager] getObjectsAtPath:_API_ENDPOINT_EVENTS_SEARCH parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
