//
//  HLSStreamDiscoveryManager.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSStreamAdvertiser.h"
#import "HLSStreamAdvertisement.h"

@interface HLSStreamAdvertisingManager : NSObject
@property (readonly) NSDictionary *advertisements;

- (id) init;
- (void) updateAdvertisementForPlaylist:(NSString *)playlist asRecordingId:(NSString *)rId withChunkCount:(NSUInteger)count;
- (BOOL) isAdvertisingRecordingId:(NSString *)rId;
- (void) stopAdvertisingRecordingId:(NSString *)rId;
- (void) stopAdvertising;

+ (HLSStreamAdvertisingManager *) discoveryManager;
+ (HLSStreamAdvertisingManager *) discoveryManagerWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser;

@end
