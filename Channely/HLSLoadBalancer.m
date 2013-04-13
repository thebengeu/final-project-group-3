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
@property (strong) NSMutableSet *_waitingForResolve;
@property (strong) NSMutableSet *_monitoredServices;
@property (strong) HLSDiscoveredRecordings *_discovered;

// Singleton Methods
- (id) initWithDomain:(NSString *)domain serviceName:(NSString *)name;

// Discovery
- (void) startDiscovery;

// Delegates
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing;
- (void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser;
- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser;
- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing;

- (void) netServiceDidResolveAddress:(NSNetService *)sender;
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;

// Logic
- (void) updateRecordingsDBWithNetService:(NSNetService *)ns forAddress:(NSString *)dd4;

// Utility
+ (NSDictionary *) decodedTXTRecordDictionaryFromNetService:(NSNetService *)ns;

@end

@implementation HLSLoadBalancer
// Internal.
@synthesize _serviceName;
@synthesize _domain;
@synthesize _browser;
@synthesize _waitingForResolve;
@synthesize _monitoredServices;
@synthesize _discovered;

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
        _waitingForResolve = [NSMutableSet set];
        _monitoredServices = [NSMutableSet set];
        _discovered = [[HLSDiscoveredRecordings alloc] init];
        
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
// When a service is found, we need to resolve its address before we can do anything useful with it.
// First add it to a collection where it will wait for the resolve to complete. Once resolved, we proccess it (in another method).
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {    
    NSLog(@"found channely host: %@", netService); // DEBUG
    
    @synchronized(_waitingForResolve) {
        [_waitingForResolve addObject:netService];
    }
    
    netService.delegate = self;
    [netService resolveWithTimeout:cNetServiceResolveTimeout];
}

- (void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"discovery stopped. restarting."); // DEBUG
    
    [_browser searchForServicesOfType:cAppServiceName inDomain:cBonjourDomain];
}

- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"discovery started."); // DEBUG
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSLog(@"netservice that went offline: %@, %@", aNetService, aNetService.name);

    
    // TODO
}

#pragma mark NetService Delegate
// Note: "A service might resolve to multiple addresses if the computer publishing the service is currently multihoming."
// Ref: https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSNetService_Class/Reference/Reference.html
// We process services with resolved addresses here. The first step is to convert the 4-byte IPv4 address to a string, which is used as a key
// for multiple dictionaries.
// We ignore the above multi-homed scenario; if a device is multi-homed, the resolved NSNetService is discarded.
- (void) netServiceDidResolveAddress:(NSNetService *)sender {
    // Remove the service from the waiting collection because it has been resolved.
    @synchronized(_waitingForResolve) {
        [_waitingForResolve removeObject:sender];
    }
    
    // If a single address could not be found, then discard the service (Unsupported number of addresses).
    NSString *ipAddr = [HLSLoadBalancer dottedDecimalFromNetService:sender];
    if (!ipAddr) {
        return;
    }
    
    // Start monitoring this service for TXT record changes.
    [sender startMonitoring];
    @synchronized(_monitoredServices) {
        [_monitoredServices addObject:sender];
    }
    
    // Update stored TXT Record Data.
    [self updateRecordingsDBWithNetService:sender forAddress:ipAddr];
}

- (void) updateRecordingsDBWithNetService:(NSNetService *)ns forAddress:(NSString *)dd4 {
    NSDictionary *advertisedByService = [HLSLoadBalancer decodedTXTRecordDictionaryFromNetService:ns];
    [advertisedByService enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *rId = (NSString *)key;
        HLSStreamAdvertisement *ad = (HLSStreamAdvertisement *)obj;
        
        HLSNetServicePathChunkCountTuple *tuple = [[HLSNetServicePathChunkCountTuple alloc] initWithNetService:ns path:ad.playlist count:ad.chunkCount];
        
        [_discovered addDiscoveredRecordingId:rId onServiceNamed:ns.name tuple:tuple];
    }];
}

// If the service fails to resolve, we discard it.
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"did not resolve service."); // DEBUG
    
    @synchronized(_waitingForResolve) {
        [_waitingForResolve removeObject:sender];
    }
}

- (void) netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    [_discovered removeDiscoveredFromServiceNamed:sender.name];
    [self updateRecordingsDBWithNetService:sender forAddress:sender.name];
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

+ (NSString *) dottedDecimalFromNetService:(NSNetService *)ns {
    // Discard service if it has an unsupported number of addresses.
    if (ns.addresses.count != 1) {
        return nil;
    }
    
    // The first element of sender.addresses represents the IPv4 address. Parse it.
    NSString *dd4 = [HLSLoadBalancer dottedDecimalFromSocketAddress:(NSData *)[ns.addresses objectAtIndex:0]];
    
    return dd4;
}

+ (NSDictionary *) decodedTXTRecordDictionaryFromNetService:(NSNetService *)ns {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSDictionary *rawRecords = [NSNetService dictionaryFromTXTRecordData:ns.TXTRecordData];
    [rawRecords enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *rId = (NSString *)key;
        NSString *recordData = [[NSString alloc] initWithData:(NSData *)obj encoding:NSUTF8StringEncoding];
        
        HLSStreamAdvertisement *ad = [HLSStreamAdvertisement advertisementFromString:recordData];
        
        [result setObject:ad forKey:rId];
    }];
    
    return result;
}

@end
