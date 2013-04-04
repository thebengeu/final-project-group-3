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
#import "ChanAPIEndpoints.h"
#import "ChanHLSRecording.h"
#import "ChanHLSChunk.h"
#import "ChanChannel.h"
#import "ChanUser.h"

@implementation ChanRestKitObjectMappings

+ (void)setup
{
    [ChanRestKitObjectMappings setupPostMappings];
    [ChanRestKitObjectMappings setupHLSMappings];
    [ChanRestKitObjectMappings setupChannelMappings];
    [ChanRestKitObjectMappings setupEventMappings];
    [ChanRestKitObjectMappings setupUserMappings];
}

+ (void)setupPostMappings
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *textPostMapping = [RKEntityMapping mappingForEntityForName:@"TextPost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [textPostMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"content":    @"content",
     @"time":       @"createdAt",
     @"username":   @"username"}];
    textPostMapping.identificationAttributes = @[ @"id" ];
    
    RKEntityMapping *imagePostMapping = [RKEntityMapping mappingForEntityForName:@"ImagePost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [imagePostMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"content":    @"content",
     @"time":       @"createdAt",
     @"url":        @"url",
     @"username":   @"username"}];
    imagePostMapping.identificationAttributes = @[ @"id" ];
    
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"text" objectMapping:textPostMapping]];
    [dynamicMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"image" objectMapping:imagePostMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping pathPattern:PATH_POSTS_UNIFIED_GET keyPath:nil statusCodes:statusCodes];
    
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

+ (void)setupHLSMappings
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *hlsRecordingMapping = [RKEntityMapping mappingForEntityForName:@"HLSRecording" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [hlsRecordingMapping addAttributeMappingsFromDictionary:@{
     @"_id":            @"id",
     @"startDate":      @"startDate",
     @"endDate":        @"endDate",
     @"endSeqNo":       @"endSeqNo",
     @"playlistURL":    @"playlistURL"}];
    hlsRecordingMapping.identificationAttributes = @[ @"id" ];
    
    RKResponseDescriptor *createRecordingDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:hlsRecordingMapping pathPattern:PATH_CREATE_RECORDING keyPath:nil statusCodes:statusCodes];
    [[RKObjectManager sharedManager] addResponseDescriptor:createRecordingDescriptor];
    
    RKResponseDescriptor *stopRecordingDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:hlsRecordingMapping pathPattern:PATH_STOP_RECORDING keyPath:nil statusCodes:statusCodes];
    [[RKObjectManager sharedManager] addResponseDescriptor:stopRecordingDescriptor];
    
    RKObjectMapping *hlsRecordingRequestMapping = [RKObjectMapping requestMapping];
    [hlsRecordingRequestMapping addAttributeMappingsFromDictionary:@{
     @"id":             @"_id",
     @"startDate":      @"startDate",
     @"endDate":        @"endDate",
     @"endSeqNo":       @"endSeqNo",
     @"playlistURL":    @"playlistURL"}];
    RKRequestDescriptor *hlsRecordingRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:hlsRecordingRequestMapping objectClass:[ChanHLSRecording class] rootKeyPath:nil];
    
    RKObjectMapping *hlsChunkRequestMapping = [RKObjectMapping requestMapping];
    [hlsChunkRequestMapping addAttributeMappingsFromDictionary:@{
     @"duration":   @"duration",
     @"seqNo":      @"seqNo"}];
    RKRequestDescriptor *hlsChunkRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:hlsChunkRequestMapping objectClass:[ChanHLSChunk class] rootKeyPath:nil];

    [[RKObjectManager sharedManager] addRequestDescriptor:hlsRecordingRequestDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:hlsChunkRequestDescriptor];
}

+ (void)setupChannelMappings
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Channel" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"_id":        @"id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    responseMapping.identificationAttributes = @[ @"id" ];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:PATH_CHANNEL keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"id":         @"_id",
     @"name":       @"name",
     @"createdAt":  @"createdAt"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[ChanChannel class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
}

+ (void)setupEventMappings
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
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:PATH_EVENTS_SEARCH keyPath:nil statusCodes:statusCodes];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

+ (void)setupUserMappings
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [responseMapping addAttributeMappingsFromDictionary:@{
     @"_id":            @"id",
     @"username":       @"name",
     @"password":       @"password",
     @"accessToken":    @"accessToken"}];
    responseMapping.identificationAttributes = @[ @"id" ];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:PATH_USER keyPath:nil statusCodes:statusCodes];
    RKResponseDescriptor *oauthResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:PATH_GET_ACCESS_TOKEN keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
     @"id":         @"_id",
     @"name":       @"username",
     @"password":   @"password"}];
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[ChanUser class] rootKeyPath:nil];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:oauthResponseDescriptor];
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
}

@end
