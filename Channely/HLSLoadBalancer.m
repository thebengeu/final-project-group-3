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
static NSUInteger const cHttpPort = 80;
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
    
    // If the recording is complete, we randomly pick a peer from the set of peers with the full recording.
    // Since the array is sorted, we scan through from index 1, stopping at the last index with a full recording.
    // Otherwise, we randomly pick a peer whose chunk count is within a defined spread radius of the top chunk count.
    // Since the array is sorted, we scan through from index 1, stopping when the above condition fails for the
    // first time.
    NSUInteger randLimit;
    for (randLimit = 1; randLimit < result.count; randLimit++) {
        HLSNetServicePathChunkCountTuple *peer = (HLSNetServicePathChunkCountTuple *)[result objectAtIndex:randLimit];
        if (completeRecordingExists && peer.chunkCount != topChunkCount) {
            break;
        } else if ((topChunkCount - peer.chunkCount) > cMaxSpreadRadius) { // ( {difference} > cMaxSpreadRadius )
            break;
        }
    }
    
    // Randomly pick a peer from the top n.
    // arc4random_uniform returns a random unint less than limit
    NSUInteger randIndex = arc4random_uniform(randLimit);
    
    HLSNetServicePathChunkCountTuple *selectedPeer = [result objectAtIndex:randIndex];
    NSString *hostIpAddr = [HLSPeerDiscovery dottedDecimalFromNetService:selectedPeer.netService];
    NSString *urlStr = [NSString stringWithFormat:cURLFormat, hostIpAddr, cHttpPort, selectedPeer.relativePath];
    
    return [NSURL URLWithString:urlStr];
}

+ (NSUInteger) totalChunksFromChunkField:(NSUInteger)chunkCount {
    return (chunkCount & cTotalChunksBitMask);
}

@end
