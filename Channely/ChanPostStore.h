//
//  ChanPostStore.h
//  Channely
//
//  Created by Beng on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChanPost;

@interface ChanPostStore : NSObject

+ (ChanPostStore *)sharedStore;
- (void)getPostsWithChannelId:(NSString *)channelId
               withCompletion:(void (^)(NSArray *posts, NSError *error))block;

@end
