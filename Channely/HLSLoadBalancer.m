//
//  ChanPeerSelection.m
//  Channely
//
//  Created by k on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSLoadBalancer.h"

static NSString *const cBonjourDomain = @"local.";
static NSString *const cAppServiceName = @"_channely._tcp.";
static NSTimeInterval const cNetServiceResolveTimeout = 5.0; // Seconds.
static NSString *const cDD4AddressZero = @"0.0.0.0";

@interface HLSLoadBalancer ()
// Internal.
@property (strong) NSString *_serviceName;
@property (strong) NSString *_domain;
@property (strong) NSNetServiceBrowser *_browser;

// Singleton Methods
- (id) initWithDomain:(NSString *)domain serviceName:(NSString *)name;

// Discovery
- (void) startDiscovery;

// Delegates
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing;
- (void) netServiceDidResolveAddress:(NSNetService *)sender;
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;

// Utility
+ (NSString *) dottedDecimalFromSocketAddress:(NSData *)dataIn;

@end

@implementation HLSLoadBalancer
// Internal.
@synthesize _serviceName;
@synthesize _domain;
@synthesize _browser;

static HLSLoadBalancer * _internal;

#pragma mark Singleton Methods
+ (HLSLoadBalancer *) setupLoadBalancer {
    if (!_internal) {
        _internal = [[HLSLoadBalancer alloc] initWithDomain:cBonjourDomain serviceName:cAppServiceName];
    }
    return _internal;
}

+ (HLSLoadBalancer *) loadBalancer {
    return _internal;
}

// Overriden default init.
- (id) init {
    return nil;
}

// Private constructor.
- (id) initWithDomain:(NSString *)domain serviceName:(NSString *)name {
    if (self = [super init]) {
        _serviceName = name;
        _domain = domain;
        
        [self startDiscovery];
    }
    return self;
}

#pragma mark Discovery
- (void) startDiscovery {
    _browser = [[NSNetServiceBrowser alloc] init];
    _browser.delegate = self;
    
    [_browser searchForServicesOfType:cAppServiceName inDomain:cBonjourDomain];
}

#pragma mark NetService Browser Delegate
// TODO
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {    

}

// TODO
- (void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    
}

#pragma mark NetService Delegate
- (void) netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"net service did resolve address."); // DEBUG
    
    for (NSData *addrData in sender.addresses) {
        NSString *dd4 = [HLSLoadBalancer dottedDecimalFromSocketAddress:addrData];
        
        // Skip processing the current address if invalid.
        if ([dd4 isEqualToString:cDD4AddressZero]) {
            continue;
        }
        
        NSDictionary *txtRecords = [NSNetService dictionaryFromTXTRecordData:sender.TXTRecordData];
        [txtRecords enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *availableRecording = (NSString *)key;
            
            NSLog(@"%@", availableRecording); // DEBUG
            
            HLSStreamAdvertisement *recordingDetails = [HLSStreamAdvertisement advertisementFromData:(NSData *)obj forPeerWithAddress:dd4];
            
            // TODO
        }];
    }
}

- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"did not resolve service.");
}

#pragma mark Peer Selection
- (NSURL *) selectBestLocalHostForRecording:(NSString *)rId {
    // TODO
    return nil;
}

#pragma mark Utility
// Note: We are assuming an IPv4 address.
// Ref: http://stackoverflow.com/questions/2327864/converting-nsnetservice-addresses-to-ip-address-string
+ (NSString *) dottedDecimalFromSocketAddress:(NSData *)dataIn {
    struct sockaddr_in *socketAddress = (struct sockaddr_in *)dataIn.bytes;
    
    // We need to convert from network byte order.
    NSString *ipString = [NSString stringWithFormat: @"%s", inet_ntoa(socketAddress->sin_addr)];
    
    return ipString;
}

@end
