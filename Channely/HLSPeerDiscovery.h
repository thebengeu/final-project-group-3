//
//  ChanPeerSelection.h
//  Channely
//
//  Created by k on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSNetServicePathChunkCountTuple.h"
#import "HLSDiscoveredRecordings.h"
#import "HLSStreamAdvertisement.h"
#import "Constants.h"

#include <arpa/inet.h>
#include <stdlib.h>

@interface HLSPeerDiscovery : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
- (id)init;

- (BOOL)recordingIsComplete:(NSString *)rId;
- (NSArray *)sortedPeersForRecording:(NSString *)rId;

+ (NSString *)dottedDecimalFromNetService:(NSNetService *)ns;

+ (HLSPeerDiscovery *)setupPeerDiscovery;
+ (HLSPeerDiscovery *)peerDiscovery;

@end
