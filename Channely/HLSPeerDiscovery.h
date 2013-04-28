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

/**
 `HLSPeerDiscovery` is a component that runs in the background, building a database of discovered peers and the recordings they can serve. It is a singleton.
 */
@interface HLSPeerDiscovery : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
/**
 Returns `nil`. `HLSPeerDiscovery` is a singleton.
 
 @return `nil`.
 */
- (id)init;


/**
 Determines if a recording is complete. Complete recordings are playlists that have a footer.
 
 @param rId The recording to query.
 
 @return `YES` if a complete recording exists, `NO` otherwise.
 */
- (BOOL)recordingIsComplete:(NSString *)rId;

/**
 Returns a list of peers that serve a recording, ordered by the number of chunks each has of that recording.
 
 @param rId The recording to query.
 
 @return `NSArray` of peers with that recording.
 */
- (NSArray *)sortedPeersForRecording:(NSString *)rId;


/**
 Represents an IPv4 address in dotted decimal format.
 
 @param ns The `NSNetService` from which to obtain the IPv4 Address.
 
 @return The address in dotted decimal format (0.0.0.0)
 */
+ (NSString *)dottedDecimalFromNetService:(NSNetService *)ns;


/**
 Initializes a single instance of `HLSPeerDiscovery` and returns a reference to it. If the object has already been initialized, then this method returns a reference to the existing copy.
 
 @return An initialized instance of this object.
 */
+ (HLSPeerDiscovery *)setupPeerDiscovery;

/**
 Returns a reference to an existing copy of `HLSPeerDiscovery`. If no such copy exists, returns `nil`.
 
 @return An initialized instance of this object, or `nil`.
 */
+ (HLSPeerDiscovery *)peerDiscovery;

@end
