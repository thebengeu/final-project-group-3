//
//  HLSStreamDiscoveryManager.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSStreamAdvertiser.h"

@interface HLSStreamDiscoveryManager : NSObject
@property (readonly) NSDictionary *advertisements;

- (id) init;
- (void) startAdvertisingPlaylist:(NSString *)playlist asRecordingId:(NSString *)rId;
- (BOOL) isAdvertisingRecordingId:(NSString *)rId;
- (void) stopAdvertisingRecordingId:(NSString *)rId;
- (void) stopAdvertising;

+ (HLSStreamDiscoveryManager *) discoveryManager;
+ (HLSStreamDiscoveryManager *) discoveryManagerWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser;

@end