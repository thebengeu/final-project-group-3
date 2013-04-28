//
//  HLSDiscoveredRecordings.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSNetServicePathChunkCountTuple.h"

/**
 A bidirectional mapping of recording id to `HLSNetServicePathChunkCountTuple`.
 The mapping is keyed on recording id, and an IP Address.
 */
@interface HLSDiscoveredRecordings : NSObject
/**
 Creates a new `HLSDiscoveredRecordings`.
 
 @return An initialized instance of this object.
 */
- (id)init;

/**
 Adds a mapping of recording id and IP Address, and stores associated data in a `HLSNetServicePathChunkCountTuple`.
 
 @param rId The recording id.
 @param addr The IP Address.
 @param tuple Additional data.
 */
- (void)addDiscoveredRecordingId:(NSString *)rId onServiceNamed:(NSString *)addr tuple:(HLSNetServicePathChunkCountTuple *)tuple;

/**
 Removes a mapping of recording id and IP Address by IP Address. Associated data is also deleted.
 
 @param ipAddr The IP Address which should be removed.
 */
- (void)removeDiscoveredFromServiceNamed:(NSString *)ipAddr;

/**
 Returns an `NSMutableArray` of `NSNetService`s which correspond to a recording id.
 
 @param rId The recording id to query.
 
 @return An `NSMutableArray` containing `NSNetService`s, or `nil` if the query could not be performed or returned no results.
 */
- (NSMutableArray *)netServicesWithRecording:(NSString *)rId;

@end
