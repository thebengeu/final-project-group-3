//
//  HLSRecordingDB.m
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSRecordingDB.h"

@interface HLSRecordingDB ()
@property (strong) NSMutableDictionary *_idToHost;
@property (strong) NSMutableDictionary *_hostToId;

- (void) addRecordingToIdHost:(HLSStreamAdvertisement *)ad;
- (void) addHostToHostId:(HLSStreamAdvertisement *)ad;

@end

@implementation HLSRecordingDB
@synthesize _idToHost;
@synthesize _hostToId;

#pragma mark Constructors
- (id) init {
    if (self = [super init]) {
        _idToHost = [NSMutableDictionary dictionary];
        _hostToId = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark External Methods
// We need to lock both dictionaries at the same time to prevent concurrent modification.
- (void) clear {
    @synchronized(_idToHost) { @synchronized(_hostToId) {
        [_idToHost removeAllObjects];
        [_hostToId removeAllObjects];
    }}
}

- (void) addRecording:(HLSStreamAdvertisement *)ad {
    [self addRecordingToIdHost:ad];
    [self addHostToHostId:ad];
}

- (void) removeRecordingsForHost:(NSString *)host {
    NSMutableArray *recordingsServedByTarget = nil;
    
    @synchronized(_hostToId) {
        recordingsServedByTarget = [_hostToId objectForKey:host];
    }
    
    // No recordings to remove.
    if (!recordingsServedByTarget) {
        return;
    }
    
    // For each advertisement host is serving, remove it from the _idToHost database.
    @synchronized(_idToHost) {
        for (HLSStreamAdvertisement *ad in recordingsServedByTarget) {
            NSString *rId = ad.recordingId;
            
            NSMutableArray *hostsForRecording = [_idToHost objectForKey:rId];
            [hostsForRecording removeObject:ad];
        }
    }
    
    // Finally, remove the corresponding host entry in hostToId database.
    @synchronized(_hostToId) {
        [_hostToId removeObjectForKey:host];
    }
}

- (NSArray *) advertisementsForRecordingId:(NSString *)rId {
    @synchronized(_idToHost) {
        NSMutableArray *ads = [_idToHost objectForKey:rId];
        
        if (!ads) {
            return nil;
        }
        
        @synchronized(ads) {
            [ads sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HLSStreamAdvertisement *data1 = (HLSStreamAdvertisement *)obj1;
                HLSStreamAdvertisement *data2 = (HLSStreamAdvertisement *)obj2;
                
                if (data1.chunkCount > data2.chunkCount) {
                    return NSOrderedAscending;
                } else if (data1.chunkCount == data2.chunkCount) {
                    return NSOrderedSame;
                } else {
                    return NSOrderedDescending;
                }
            }];
            
            return ads;
        }
    }
}

#pragma mark Logic
- (void) addRecordingToIdHost:(HLSStreamAdvertisement *)ad {
    @synchronized(_idToHost) {
        // If there is no host currently serving the recording, then create a new array.
        // Otherwise, use the existing array.
        NSMutableArray *hostsServingRecording = [_idToHost objectForKey:ad.recordingId];
        if (!hostsServingRecording) {
            hostsServingRecording = [NSMutableArray array];
        }
        
        // Add the new advertisement to the array of hosts serving recording.
        @synchronized(hostsServingRecording) {
            [hostsServingRecording addObject:ad];
        }
        
        // Add the array to the dictionary.
        [_idToHost setObject:hostsServingRecording forKey:ad.recordingId];
    }
}

- (void) addHostToHostId:(HLSStreamAdvertisement *)ad {
    @synchronized(_hostToId) {
        NSMutableArray *recordingsServed = [_hostToId objectForKey:ad.hostDD4];
        if (!recordingsServed) {
            recordingsServed = [NSMutableArray array];
        }
        
        @synchronized(recordingsServed) {
            [recordingsServed addObject:ad];
        }
        
        [_hostToId setObject:recordingsServed forKey:ad.hostDD4];
    }
}

@end
