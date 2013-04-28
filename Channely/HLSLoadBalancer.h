//
//  HLSLoadBalancer.h
//  Channely
//
//  Created by Camillus Gerard Cai on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSPeerDiscovery.h"
#import "HLSStreamSync.h"
#import "Constants.h"

/**
 This class implements an algorithm to select the best source for a given recording.
 */
@interface HLSLoadBalancer : NSObject
/**
 Selects the best source for a recording.
 
 @param rId The recording Id for which to select a source.
 @param serverSource A default source that is always available.
 
 @return The URL of the selected source.
 */
+ (NSURL *)selectBestLocalHostForRecording:(NSString *)rId default:(NSURL *)serverSource;

@end
