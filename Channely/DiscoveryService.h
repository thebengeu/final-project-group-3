//
//  BonjourService.h
//  Channely
//
//  Created by k on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/*  Creation example: [[DiscoverService alloc]initWithServiceName: @"channely" :@"recordingId"]
 *  Advertise example: [self advertiseService]
 *  Stop advertise example: [self stopAdvertiseService]
 *  Discover example: [self startDiscover]
 *  Discover status/results: Use DiscoverServiceDelegate
 *
 */

#import <Foundation/Foundation.h>

@protocol DiscoveryServiceDelegate

- (void) discovered:(NSString*)ipAddress;
- (void) discoveryEnded: (Boolean)hasError :(NSDictionary*)error;

@end



@interface DiscoveryService : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property NSString *serviceName;

@property (readonly) NSString *serverName;

-(id)initWithServiceName:(NSString*)serviceName :(NSString*)recordingId;

-(void)advertiseService;

-(void)stopAdvertiseService;

-(void)startDiscover;

@property id<DiscoveryServiceDelegate> delegate;

@end
