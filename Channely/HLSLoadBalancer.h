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

@interface HLSLoadBalancer : NSObject
+ (NSURL *)selectBestLocalHostForRecording:(NSString *)rId default:(NSURL *)serverSource;

@end
