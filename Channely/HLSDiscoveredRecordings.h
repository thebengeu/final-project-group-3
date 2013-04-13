//
//  HLSDiscoveredRecordings.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSNetServicePathChunkCountTuple.h"
#import "HLSLoadBalancer.h"

@interface HLSDiscoveredRecordings : NSObject

- (id) init;
- (void) addDiscoveredRecordingId:(NSString *)rId at:(NSString *)addr tuple:(HLSNetServicePathChunkCountTuple *)tuple;
- (void) removeDiscoveredFrom:(NSString *)ipAddr;

@end
