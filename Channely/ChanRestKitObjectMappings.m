//
//  ChanRestKitObjectMappings.m
//  Channely
//
//  Created by Beng on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRestKitObjectMappings.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"

NSString *const _API_ENDPOINT_POSTS_UNIFIED_GET = @"/channels/:channelID/posts";

@implementation ChanRestKitObjectMappings

+ (void)setup
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
    
    RKObjectMapping *textPostRequestMapping = [RKObjectMapping requestMapping];
    [textPostRequestMapping addAttributeMappingsFromDictionary:@{
     @"channel.id": @"_channel",
     @"content":  @"content"}];
    RKRequestDescriptor *textPostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:textPostRequestMapping objectClass:[ChanTextPost class] rootKeyPath:nil];
    
    RKObjectMapping *imagePostRequestMapping = [RKObjectMapping requestMapping];
    [imagePostRequestMapping addAttributeMappingsFromDictionary:@{
     @"channel.id": @"_channel",
     @"content":  @"content"}];
    RKRequestDescriptor *imagePostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:imagePostRequestMapping objectClass:[ChanImagePost class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:textPostRequestDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:imagePostRequestDescriptor];
}

@end
