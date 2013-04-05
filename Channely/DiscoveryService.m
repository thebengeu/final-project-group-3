//
//  BonjourService.m
//  Channely
//
//  Created by k on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiscoveryService.h"
#include <arpa/inet.h>

@interface DiscoveryService()

@property NSString *serverName;

@property NSNetService *netService;

@property NSNetService *foundNetService;

@property NSNetServiceBrowser *browser;

@property NSString *domain;

@end



@implementation DiscoveryService

-(id)initWithServiceName:(NSString *)serviceName :(NSString*)recordingId{
    self = [super init];
    if (self){
        [self setServiceName:serviceName];
        _serverName = recordingId;
        _domain = @"local.";
        _netService = [[NSNetService alloc] initWithDomain:_domain
                                                                   type:[NSString stringWithFormat:@"_%@._tcp.", _serviceName]
                                                                   name:_serverName
                                                                   port:41337];
        [_netService setDelegate:self];
        _browser = [[NSNetServiceBrowser alloc] init];
        [_browser setDelegate:self];
    }
    return self;
}

-(void)advertiseService{
    [_netService publish];
}

-(void)stopAdvertiseService{
    [_netService stop];
}

-(void)startDiscover{
    [_browser searchForServicesOfType:[NSString stringWithFormat:@"_%@._tcp.", _serviceName]
                            inDomain:_domain];
}


- (NSString *)getStringFromAddressData:(NSData *)dataIn {
    struct sockaddr_in  *socketAddress = nil;
    NSString            *ipString = nil;
    
    socketAddress = (struct sockaddr_in *)[dataIn bytes];
    ipString = [NSString stringWithFormat: @"%s",
                inet_ntoa(socketAddress->sin_addr)];  ///problem here
    return ipString;
}

//  Net browser delegate methods
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
    _foundNetService = netService;
    [_foundNetService setDelegate:self];
    [_foundNetService resolveWithTimeout:5];

    //NSLog(@"NetServiceBrowser Found: %@", [netService description]);
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    for (NSData *addressData in [sender addresses]){
        NSString *address = [self getStringFromAddressData:addressData];
        if ([address compare:@"0.0.0.0"] != NSOrderedSame)
            [[self delegate]discovered:address];
    }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser{
    [[self delegate]discoveryEnded: NO :nil];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo{
    [[self delegate]discoveryEnded:YES :errorInfo];
}




//  Net service delegate methods
- (void)netService:(NSNetService *)netService
     didNotPublish:(NSDictionary *)errorDict{
    NSLog(@"NetService will not publish %@", [netService description]);
    NSEnumerator *e = [errorDict objectEnumerator];
    while (true){
        id o = [e nextObject];
        if (!o)
            break;
        NSLog(@"%@", [o description]);
    }
}



@end
