//
//  HLSLoadBalancer.m
//  Channely
//
//  Created by Camillus Gerard Cai on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSLoadBalancer.h"

static NSUInteger const cCompleteRecordingBitMask = 0x80000000;
static NSUInteger const cMaxSpreadRadius = 5;
static NSString *const cURLFormat = @"http://%@:%d/%@";
static NSUInteger const cHttpPort = 22;
static NSUInteger const cTotalChunksBitMask = 0x7FFFFFFF;
static NSString *const cLocalhost = @"127.0.0.1";

@interface HLSLoadBalancer ()
+ (NSUInteger) totalChunksFromChunkField:(NSUInteger)chunkCount;

@end

@implementation HLSLoadBalancer
+ (NSURL *) selectBestLocalHostForRecording:(NSString *)rId default:(NSURL *)serverSource {
    // If a complete device-local source exists, always select it.
    if ([[HLSStreamSync streamSync] completeLocalStreamExistsForStreamId:rId]) {
        NSString *relativePath = [rId stringByAppendingPathComponent:[serverSource lastPathComponent]];
        NSString *localURLStr = [NSString stringWithFormat:cURLFormat, cLocalhost, cHttpPort, relativePath];
        return [NSURL URLWithString:localURLStr];
    }
    
    // Otherwise, get a list of peers who have the recording.
    NSArray *result = [[HLSPeerDiscovery peerDiscovery] sortedPeersForRecording:rId];
    NSLog(@"%@", result);
    
    // If nobody has the recording, use the default server source.
    if (!result) {
        return serverSource;
    }
    
    // Determine if a recording is complete, and the top number of chunks at the time of query.
    BOOL completeRecordingExists = NO;
    NSUInteger firstChunkField = ((HLSNetServicePathChunkCountTuple *)[result objectAtIndex:0]).chunkCount;
    if (firstChunkField & cCompleteRecordingBitMask) {
        completeRecordingExists = YES;
        NSLog(@"found completed recording."); // DEBUG
    }
    NSUInteger topChunkCount = [HLSLoadBalancer totalChunksFromChunkField:firstChunkField];
    
    
    // If the recording is complete, we build the set of peers with the full recording.
    // Since the array is sorted, we scan through from index 1, stopping at the last index with a full recording.
    // Otherwise, we build the set of peers whose chunk count is within a defined spread radius of the top chunk count.
    // Since the array is sorted, we scan through from index 1, stopping when the above condition fails for the
    // first time.
    NSMutableArray *sourcePool = [NSMutableArray array];
    for (NSUInteger randLimit = 1; randLimit < result.count; randLimit++) {
        HLSNetServicePathChunkCountTuple *peer = (HLSNetServicePathChunkCountTuple *)[result objectAtIndex:randLimit];
        if (completeRecordingExists && peer.chunkCount != topChunkCount) {
            break;
        } else if ((topChunkCount - peer.chunkCount) > cMaxSpreadRadius) { // ( {difference} > cMaxSpreadRadius )
            break;
        } else {
            [sourcePool addObject:peer];
        }
    }
    
    NSURL *selectedURL = nil;
    BOOL peerReachable = NO;
    while (!peerReachable) {
        // If there are no more reachable peers left from the array, return the default source.
        if (sourcePool.count == 0) {
            return serverSource;
        }
        
        // Otherwise, randomly pick a peer from the set of available sources.
        // arc4random_uniform returns a random unint less than limit
        NSUInteger randIndex = arc4random_uniform(sourcePool.count);
        HLSNetServicePathChunkCountTuple *selectedPeer = [result objectAtIndex:randIndex];
        NSString *hostIpAddr = [HLSPeerDiscovery dottedDecimalFromNetService:selectedPeer.netService];
        NSString *urlStr = [NSString stringWithFormat:cURLFormat, hostIpAddr, cHttpPort, selectedPeer.relativePath];
        
        // Test if the peer is reachable by attempting to download the playlist.
        selectedURL = [NSURL URLWithString:urlStr];
        NSError *error;
        if ([selectedURL checkResourceIsReachableAndReturnError:&error]) {
            NSLog(@"playlist:%@ was reachable. returning.", [selectedURL absoluteString]); // DEBUG.
            peerReachable = YES;
        } else {
            NSLog(@"playlist could not be reached. error:%@", error); // DEBUG.
            [sourcePool removeObjectAtIndex:randIndex];
        }
    }
    
    return selectedURL;
}

+ (NSUInteger) totalChunksFromChunkField:(NSUInteger)chunkCount {
    return (chunkCount & cTotalChunksBitMask);
}

@end
