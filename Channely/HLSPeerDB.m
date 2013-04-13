//
//  HLSPeerDB.m
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSPeerDB.h"

@interface HLSPeerDB ()
@property (strong) NSMutableDictionary *_peers;

@end

@implementation HLSPeerDB
@synthesize _peers;

- (void) addP2Peer:(NSNetService *)netService forHost:(NSString *)hostDD4 {
    @synchronized(_peers) {
        [_peers setObject:netService forKey:hostDD4];
    }
}

- (void) removeP2Peer:(NSString *)hostDD4 {
    @synchronized(_peers) {
        [_peers removeObjectForKey:hostDD4];
    }
}

- (void) removeP2PeersInArray:(NSArray *)array {
    @synchronized(_peers) {
        for (NSString *host in array) {
            [_peers removeObjectForKey:host];
        }
    }
}

#pragma mark External Accessors
// The result of this method needs to be externally synchronized.
- (NSDictionary *) peers {
    return (NSDictionary *)self._peers;
}

@end
