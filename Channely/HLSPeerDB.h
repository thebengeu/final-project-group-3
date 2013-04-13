//
//  HLSPeerDB.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSPeerDB : NSObject
@property (readonly, strong) NSDictionary *peers;

- (void) addP2Peer:(NSNetService *)netService forHost:(NSString *)hostDD4;
- (void) removeP2Peer:(NSString *)hostDD4;
- (void) removeP2PeersInArray:(NSArray *)array;

@end
