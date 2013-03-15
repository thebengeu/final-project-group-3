//
//  ChanTimelineStore.m
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanTimelineStore.h"

@implementation ChanTimelineStore

+ (ChanTimelineStore *)sharedStore
{
    static ChanTimelineStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[ChanTimelineStore alloc] init];
    }
    return sharedStore;
}

- (void)getAllTimelinesWithCompletion:(void (^)(NSArray *timelines, NSError *error))block
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/timelines" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
