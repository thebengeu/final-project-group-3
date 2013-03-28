//
//  ChanChannelStore.m
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanChannelStore.h"

#import "ChanChannel.h"

@implementation ChanChannelStore

NSString *const _API_ENDPOINT_CHANNEL = @"/channels";

+ (ChanChannelStore *)sharedStore
{
    static ChanChannelStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[ChanChannelStore alloc] init];
    }
    return sharedStore;
}

- (id)init
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Channel" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    responseMapping.identificationAttributes = @[ @"id" ];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:_API_ENDPOINT_CHANNEL keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"id":         @"_id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[ChanChannel class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    
    return self;
}

- (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block
{
    [[RKObjectManager sharedManager] getObjectsAtPath:_API_ENDPOINT_CHANNEL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addChannel:(ChanChannel *)channel withCompletion:(void (^)(ChanChannel *channel, NSError *error))block
{
    [[RKObjectManager sharedManager] postObject:channel path:_API_ENDPOINT_CHANNEL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(channel, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
