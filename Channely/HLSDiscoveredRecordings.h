//
//  HLSDiscoveredRecordings.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSNetServicePathChunkCountTuple.h"

@interface HLSDiscoveredRecordings : NSObject

- (id) init;
- (void) addDiscoveredRecordingId:(NSString *)rId onServiceNamed:(NSString *)addr tuple:(HLSNetServicePathChunkCountTuple *)tuple;
- (void) removeDiscoveredFromServiceNamed:(NSString *)ipAddr;
- (NSMutableArray *) netServicesWithRecording:(NSString *)rId;

@end
