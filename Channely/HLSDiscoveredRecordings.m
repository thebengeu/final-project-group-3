//
//  HLSDiscoveredRecordings.m
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSDiscoveredRecordings.h"

@interface HLSDiscoveredRecordings ()
// Internal.
@property (strong) NSMutableDictionary *_nameToRecordingId; // (NSString => NSMutableArray[NSString])
@property (strong) NSMutableDictionary *_recordingIdToTuple; // (NSString => NSMutableArray[HLS...Tuple])

@end

@implementation HLSDiscoveredRecordings
// Internal.
@synthesize _nameToRecordingId;
@synthesize _recordingIdToTuple;

#pragma mark Constructors
- (id)init
{
    if (self = [super init]) {
        _nameToRecordingId = [NSMutableDictionary dictionary];
        _recordingIdToTuple = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark External Methods
- (void)addDiscoveredRecordingId:(NSString *)rId onServiceNamed:(NSString *)addr tuple:(HLSNetServicePathChunkCountTuple *)tuple
{
    // Add the record in the forward dictionary.
    @synchronized(_nameToRecordingId) {
        NSMutableArray *nameRecord = [_nameToRecordingId objectForKey:addr];
        if (!nameRecord) {
            nameRecord = [NSMutableArray array];
        }
        @synchronized(nameRecord) {
            [nameRecord addObject:rId];
        }
        [_nameToRecordingId setObject:nameRecord forKey:addr];
    }
    
    // Add the record in the reverse dictionary.
    @synchronized(_recordingIdToTuple) {
        NSMutableArray *rIdRecord = [_recordingIdToTuple objectForKey:rId];
        if (!rIdRecord) {
            rIdRecord = [NSMutableArray array];
        }
        @synchronized(rIdRecord) {
            [rIdRecord addObject:tuple];
        }
        [_recordingIdToTuple setObject:rIdRecord forKey:rId];
    }
}

- (void)removeDiscoveredFromServiceNamed:(NSString *)name
{
    // Get the recording Ids that ipAddr is serving.
    NSMutableArray *served = nil;
    @synchronized(_nameToRecordingId) {
        served = [_nameToRecordingId objectForKey:name];
    }
    
    // If ipAddr does not exist, do nothing.
    if (!served) {
        return;
    }
    
    // Enumerate through the reverse dictionary, removing the target host from each recordingId.
    @synchronized(served) {
        @synchronized(_recordingIdToTuple) {
            for (NSString *rId in served) {
                NSMutableArray *serversHostingRId = [_recordingIdToTuple objectForKey:rId];
                
                // If there are no servers hosting rId (this is a race condition), then do nothing.
                if (!serversHostingRId) {
                    continue;
                }
                
                BOOL shouldRemoveThisRId = NO;
                NSMutableArray *tuplesToRemove = [NSMutableArray array];
                @synchronized(serversHostingRId) {
                    for (HLSNetServicePathChunkCountTuple *tuple in serversHostingRId) {
                        if ([tuple.netService.name isEqualToString:name]) {
                            [tuplesToRemove addObject:tuple];
                        }
                    }
                    
                    [serversHostingRId removeObjectsInArray:tuplesToRemove];
                    
                    // If no servers are hosting this record after removal, then indicate that we should delete the corresponding key.
                    if (serversHostingRId.count == 0) {
                        shouldRemoveThisRId = YES;
                    }
                }
                
                // Remove the key if the flag is set.
                if (shouldRemoveThisRId) {
                    [_recordingIdToTuple removeObjectForKey:rId];
                }
            }
        }
    }
    
    // Finally, remove the target ipAddr from the forward dictionary.
    @synchronized(_nameToRecordingId) {
        [_nameToRecordingId removeObjectForKey:name];
    }
}

- (NSMutableArray *)netServicesWithRecording:(NSString *)rId
{
    NSMutableArray *array = nil;
    @synchronized(_recordingIdToTuple) {
        array = [_recordingIdToTuple objectForKey:rId];
    }
    
    if (!array) {
        return nil;
    }
    
    NSMutableArray *result = nil;
    @synchronized(array) {
        result = [NSMutableArray arrayWithArray:array];
    }
    
    return result;
}

@end
