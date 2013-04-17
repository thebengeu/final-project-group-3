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

#include <arpa/inet.h>
#include <stdlib.h>

@interface HLSPeerDiscovery : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
- (id) init;
- (NSURL *) selectBestLocalHostForRecording:(NSString *)rId default:(NSURL *)serverSource;

+ (HLSPeerDiscovery *) setupPeerDiscovery;
+ (HLSPeerDiscovery *) peerDiscovery;

@end
