//
//  ChanTimelineStore.h
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChanTimeline;

@interface ChanTimelineStore : NSObject

+ (ChanTimelineStore *)sharedStore;
- (void)getAllTimelinesWithCompletion:(void (^)(NSArray *timelines, NSError *error))block;
- (void)addTimeline:(ChanTimeline *)timeline withCompletion:(void (^)(ChanTimeline *timeline, NSError *error))block;

@end
