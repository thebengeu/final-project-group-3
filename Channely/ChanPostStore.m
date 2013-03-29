//
//  ChanPostStore.m
//  Channely
//
//  Created by Beng on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostStore.h"
#import "ChanPost.h"

@implementation ChanPostStore

NSString *const _API_ENDPOINT_POSTS_UNIFIED_GET = @"/channels/:channelID/posts";

+ (ChanPostStore *)sharedStore
{
    static ChanPostStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[ChanPostStore alloc] init];
    }
    return sharedStore;
}

- (id)init
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

    RKEntityMapping *textPostMapping = [RKEntityMapping mappingForEntityForName:@"TextPost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [textPostMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"content":    @"content",
     @"time":       @"createdAt"}];
    textPostMapping.identificationAttributes = @[ @"id" ];

    RKEntityMapping *imagePostMapping = [RKEntityMapping mappingForEntityForName:@"ImagePost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [imagePostMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"content":    @"content",
     @"time":       @"createdAt",
     @"url":        @"url"}];
    imagePostMapping.identificationAttributes = @[ @"id" ];

    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"text" objectMapping:textPostMapping]];
    [dynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"image" objectMapping:imagePostMapping]];
        
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping pathPattern:_API_ENDPOINT_POSTS_UNIFIED_GET keyPath:nil statusCodes:statusCodes];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    return self;
}

- (void)getPostsWithChannelId:(NSString *)channelId
               withCompletion:(void (^)(NSArray *posts, NSError *error))block {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:@"/channels/%@/posts", channelId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
