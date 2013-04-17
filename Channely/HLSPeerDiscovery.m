//
//  ChanPeerSelection.m
//  Channely
//
//  Created by k on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSPeerDiscovery.h"

static NSString *const cBonjourDomain = @"local.";
static NSString *const cAppServiceName = @"_channely._tcp.";
static NSTimeInterval const cNetServiceResolveTimeout = 5.0; // Seconds.
static NSString *const cDD4AddressZero = @"0.0.0.0";
static NSUInteger const cRandomMax = 5;
static NSString *const cURLFormat = @"http://%@:%d/%@";
static NSUInteger const cHttpPort = 80;
static NSUInteger const cCompleteRecordingBitMask = 0x80000000;
static NSUInteger const cTotalChunksBitMask = 0x7FFFFFFF;
static NSUInteger const cMaxSpreadRadius = 5;

@interface HLSPeerDiscovery ()
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
- (void) updateRecordingsDBWithNetServiceNamed:(NSNetService *)ns adDictionary:(NSDictionary *)dict;

// Utility
+ (NSDictionary *) decodedTXTRecordDictionaryFromData:(NSData *)data;
+ (NSUInteger) totalChunksFromChunkField:(NSUInteger)chunkCount;
+ (NSString *) dottedDecimalFromSocketAddress:(NSData *)dataIn;
+ (NSString *) dottedDecimalFromNetService:(NSNetService *)ns;

@end

@implementation HLSPeerDiscovery
// Internal.
@synthesize _serviceName;
@synthesize _domain;
@synthesize _browser;
@synthesize _waitingForResolve;
@synthesize _monitoredServices;
@synthesize _discovered;

static HLSPeerDiscovery * _internal;

#pragma mark Singleton Methods
+ (HLSPeerDiscovery *) setupPeerDiscovery {
    if (!_internal) {
        _internal = [[HLSPeerDiscovery alloc] initWithDomain:cBonjourDomain serviceName:cAppServiceName];
    }
    return _internal;
}

+ (HLSPeerDiscovery *) peerDiscovery {
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

    [_discovered removeDiscoveredFromServiceNamed:aNetService.name];
}

#pragma mark NetService Delegate
// Note: "A service might resolve to multiple addresses if the computer publishing the service is currently multihoming."
// Ref: https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/Foundation/Classes/NSNetService_Class/Reference/Reference.html
// We process services with resolved addresses here. The first step is to convert the 4-byte IPv4 address to a string, which is used as a key
// for multiple dictionaries.
// We ignore the above multi-homed scenario; if a device is multi-homed, the resolved NSNetService is discarded.
- (void) netServiceDidResolveAddress:(NSNetService *)sender {   
    NSLog(@"service: %@ got resolved.", sender); // DEBUG
    
    // Remove the service from the waiting collection because it has been resolved.
    @synchronized(_waitingForResolve) {
        [_waitingForResolve removeObject:sender];
    }
    
    // If a single address could not be found, then discard the service (Unsupported number of addresses).
    NSString *ipAddr = [HLSPeerDiscovery dottedDecimalFromNetService:sender];
    if (!ipAddr) {
        return;
    }
    
    // Start monitoring this service for TXT record changes.
    NSLog(@"service delegate: %@", sender.delegate);
    [sender startMonitoring];
    @synchronized(_monitoredServices) {
        [_monitoredServices addObject:sender];
    }
}

- (void) updateRecordingsDBWithNetServiceNamed:(NSNetService *)ns adDictionary:(NSDictionary *)dict {
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *rId = (NSString *)key;
        HLSStreamAdvertisement *ad = (HLSStreamAdvertisement *)obj;
        NSLog(@"host=%@, advertisement=%@", ns.name, ad);
        
        HLSNetServicePathChunkCountTuple *tuple = [[HLSNetServicePathChunkCountTuple alloc] initWithNetService:ns path:ad.playlist count:ad.chunkCount];
        
        [_discovered addDiscoveredRecordingId:rId onServiceNamed:ns.name tuple:tuple];
    }];
}

// If the service fails to resolve, we discard it.
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"did not resolve service: %@", sender); // DEBUG
    
    @synchronized(_waitingForResolve) {
        [_waitingForResolve removeObject:sender];
    }
}

- (void) netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSDictionary *dict = [HLSPeerDiscovery decodedTXTRecordDictionaryFromData:data];
    [_discovered removeDiscoveredFromServiceNamed:sender.name];
    [self updateRecordingsDBWithNetServiceNamed:sender adDictionary:dict];
}

#pragma mark Peer Selection
- (NSURL *) selectBestLocalHostForRecording:(NSString *)rId default:(NSURL *)serverSource {
    // Retrieve a list of peers hosting rId.
    NSMutableArray *result = [_discovered netServicesWithRecording:rId];
    
    // If no peers a hosting that recording, return the default source.
    if (result.count == 0) {
        return serverSource;
    }
    
    // Sort the list.
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HLSNetServicePathChunkCountTuple *tuple1 = (HLSNetServicePathChunkCountTuple *)obj1;
        HLSNetServicePathChunkCountTuple *tuple2 = (HLSNetServicePathChunkCountTuple *)obj2;
        
        if (tuple1.chunkCount > tuple2.chunkCount) {
            return NSOrderedAscending;
        } else if (tuple1.chunkCount == tuple2.chunkCount) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    // Determine if a recording is complete, and the top number of chunks at the time of query.
    BOOL completeRecordingExists = NO;
    NSUInteger firstChunkField = ((HLSNetServicePathChunkCountTuple *)[result objectAtIndex:0]).chunkCount;
    if (firstChunkField & cCompleteRecordingBitMask) {
        completeRecordingExists = YES;
        NSLog(@"found completed recording."); // DEBUG
    }
    NSUInteger topChunkCount = [HLSPeerDiscovery totalChunksFromChunkField:firstChunkField];
    
    // If the recording is complete, we randomly pick a peer from the set of peers with the full recording.
    // Since the array is sorted, we scan through from index 1, stopping at the last index with a full recording.
    // Otherwise, we randomly pick a peer whose chunk count is within a defined spread radius of the top chunk count.
    // Since the array is sorted, we scan through from index 1, stopping when the above condition fails for the
    // first time.
    NSUInteger randLimit;
    for (randLimit = 1; randLimit < result.count; randLimit++) {
        HLSNetServicePathChunkCountTuple *peer = (HLSNetServicePathChunkCountTuple *)[result objectAtIndex:randLimit];
        if (completeRecordingExists && peer.chunkCount != topChunkCount) {
            break;
        } else if ((topChunkCount - peer.chunkCount) > cMaxSpreadRadius) { // ( {difference} > cMaxSpreadRadius )
            break;
        }
    }
    
    // Randomly pick a peer from the top n.
    // arc4random_uniform returns a random unint less than limit
    NSUInteger randIndex = arc4random_uniform(randLimit);
    
    HLSNetServicePathChunkCountTuple *selectedPeer = [result objectAtIndex:randIndex];
    NSString *hostIpAddr = [HLSPeerDiscovery dottedDecimalFromNetService:selectedPeer.netService];
    NSString *urlStr = [NSString stringWithFormat:cURLFormat, hostIpAddr, cHttpPort, selectedPeer.relativePath];
    
    return [NSURL URLWithString:urlStr];
}

// There is no need to sort the array if we only want to test if the recording is complete.
- (BOOL) recordingIsComplete:(NSString *)rId {
    // Retrieve a list of peers hosting rId.
    NSMutableArray *result = [_discovered netServicesWithRecording:rId];
    
    // If no peers a hosting that recording, we define it as incomplete.
    if (result.count == 0) {
        return NO;
    }
    
    for (HLSNetServicePathChunkCountTuple *peer in result) {
        if (peer.chunkCount & cCompleteRecordingBitMask) {
            return YES;
        }
    }
    
    return NO;
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
    if (ns.addresses.count != 2) {
        return nil;
    }
    
    // The first element of sender.addresses represents the IPv4 address. Parse it.
    NSString *dd4 = [HLSPeerDiscovery dottedDecimalFromSocketAddress:(NSData *)[ns.addresses objectAtIndex:0]];
    
    return dd4;
}

+ (NSDictionary *) decodedTXTRecordDictionaryFromData:(NSData *)data {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSDictionary *rawRecords = [NSNetService dictionaryFromTXTRecordData:data];
    [rawRecords enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *rId = (NSString *)key;
        NSString *recordData = [[NSString alloc] initWithData:(NSData *)obj encoding:NSUTF8StringEncoding];

        HLSStreamAdvertisement *ad = [HLSStreamAdvertisement advertisementFromString:recordData];
        
        [result setObject:ad forKey:rId];
    }];
    
    return result;
}

+ (NSUInteger) totalChunksFromChunkField:(NSUInteger)chunkCount {
    return (chunkCount & cTotalChunksBitMask);
}

@end
