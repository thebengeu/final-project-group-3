//
//  ChanTimelineStore.m
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTimelineStore.h"

#import "ChanTimeline.h"

@implementation ChanTimelineStore

+ (ChanTimelineStore *)sharedStore
{
    static ChanTimelineStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[ChanTimelineStore alloc] init];
    }
    return sharedStore;
}

- (id)init
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Timeline" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    responseMapping.identificationAttributes = @[ @"id" ];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:@"/timelines" keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"id":         @"_id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[ChanTimeline class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    return self;
}

- (void)getAllTimelinesWithCompletion:(void (^)(NSArray *timelines, NSError *error))block
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/timelines" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addTimeline:(ChanTimeline *)timeline withCompletion:(void (^)(ChanTimeline *timeline, NSError *error))block
{
    [[RKObjectManager sharedManager] postObject:timeline path:@"/timelines" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(timeline, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
