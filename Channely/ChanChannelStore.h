//
//  ChanChannelStore.h
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChanChannel;

@interface ChanChannelStore : NSObject

+ (ChanChannelStore *)sharedStore;
- (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block;
- (void)addChannel:(ChanChannel *)channel withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;

@end
