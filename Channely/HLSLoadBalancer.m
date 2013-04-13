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
static NSTimeInterval const cServiceTimerInterval = 15.0; // Seconds.
static NSTimeInterval const cDiscoveredEntryTTL = 30.0; // Seconds.
static NSUInteger const cTopPeers = 5;
static NSString *const cURLStringFormat = @"http://%@:%d/%@";
static NSUInteger const cHttpPort = 80;
static NSUInteger const cChunkMaxDifference = 3;

@interface HLSLoadBalancer ()
// Internal.
@property (strong) NSString *_serviceName;
@property (strong) NSString *_domain;
@property (strong) NSNetServiceBrowser *_browser;
@property (atomic, strong) NSMutableDictionary *_discoveredRecordings;
@property (strong) NSTimer *_resolveTimer;
@property (strong) NSMutableSet *_discoveredServices;

// Singleton Methods
- (id) initWithDomain:(NSString *)domain serviceName:(NSString *)name;

// Discovery
- (void) startDiscovery;

// Delegates
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing;
- (void) netServiceDidResolveAddress:(NSNetService *)sender;
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;

// Service Timer
- (void) resolveTimerDidTick:(NSTimer *)timer;
- (void) clearDiscoveredRecordings;
- (void) resolveDiscoveredServices;

// Utility
+ (void) removeAdvertisementsFromArray:(NSMutableArray *)array olderThan:(NSTimeInterval)limit;
+ (NSString *) dottedDecimalFromSocketAddress:(NSData *)dataIn;

@end

@implementation HLSLoadBalancer
// Internal.
@synthesize _serviceName;
@synthesize _domain;
@synthesize _browser;
@synthesize _discoveredRecordings;
@synthesize _resolveTimer;
@synthesize _discoveredServices;

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
        _discoveredRecordings = [NSMutableDictionary dictionary];
        _discoveredServices = [NSMutableSet set];
        
        [self startDiscovery];
    }
    return self;
}

#pragma mark Discovery
- (void) startDiscovery {
    _browser = [[NSNetServiceBrowser alloc] init];
    _browser.delegate = self;
    
    [_browser searchForServicesOfType:cAppServiceName inDomain:cBonjourDomain];
    
    _resolveTimer = [NSTimer scheduledTimerWithTimeInterval:cServiceTimerInterval target:self selector:@selector(resolveTimerDidTick:) userInfo:nil repeats:YES];
}

#pragma mark NetService Browser Delegate
- (void) netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {    
    NSLog(@"netservicebrowser found service."); // DEBUG
    
    // Store a reference to the service so we can periodically resolve it.
    @synchronized(_discoveredServices) {
        NSLog(@"service=%@", netService);
        [_discoveredServices addObject:netService];
    }
    
    if (!moreServicesComing) {
        [_browser searchForServicesOfType:cAppServiceName inDomain:cBonjourDomain];
    }
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
            
            @synchronized(_discoveredRecordings) {
                NSMutableArray *hostingPeers = [_discoveredRecordings objectForKey:availableRecording];
                
                if (hostingPeers) {
                    @synchronized(hostingPeers) {
                        [hostingPeers addObject:recordingDetails];
                    }
                } else {
                    // No need to synchronize here because we're adding a new array.
                    NSMutableArray *discovered = [NSMutableArray arrayWithObject:recordingDetails];
                    [_discoveredRecordings setObject:discovered forKey:availableRecording];
                }
            }
        }];
    }
}

- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"did not resolve service.");
    
    // If we failed to resolve a service that was previously discovered, remove it from the list of discovered services.
    [_discoveredServices removeObject:sender];
}

#pragma mark Service Timer
- (void) resolveTimerDidTick:(NSTimer *)timer {
    [self clearDiscoveredRecordings];
    [self resolveDiscoveredServices];
}

- (void) clearDiscoveredRecordings {
    @synchronized(_discoveredRecordings) {
        [_discoveredRecordings removeAllObjects];
    }
}

- (void) resolveDiscoveredServices {
    NSLog(@"re-resolving services.");
    @synchronized(_discoveredServices) {
        [_discoveredServices enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSNetService *service = (NSNetService *)obj;
            [service resolveWithTimeout:cNetServiceResolveTimeout];
        }];
    }
    NSLog(@"finished resolving services.");
}

#pragma mark Peer Selection
- (NSURL *) selectBestLocalHostForRecording:(NSString *)rId {
    HLSStreamAdvertisement *selectedData = nil;
    
    @synchronized(_discoveredRecordings) {
        NSLog(@"%@", _discoveredRecordings); // DEBUG
        
        NSMutableArray *hostingPeers = [_discoveredRecordings objectForKey:rId];
        
        // Case where a local peer that hosts the content does not exist.
        if (!hostingPeers) {
            return nil;
        }
        
        @synchronized(hostingPeers) {
            // Sort hostingPeers in descending order.
            [hostingPeers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                HLSAdvertisementData *data1 = (HLSStreamAdvertisement *)obj1;
                HLSAdvertisementData *data2 = (HLSStreamAdvertisement *)obj2;
                
                if (data1.chunkCount > data2.chunkCount) {
                    return NSOrderedAscending;
                } else if (data1.chunkCount == data2.chunkCount) {
                    return NSOrderedSame;
                } else {
                    return NSOrderedDescending;
                }
            }];
            
            NSLog(@"hostingPeers=%@", hostingPeers); // DEBUG
            
            // Random peer selection for load balancing.
            if (hostingPeers.count == 0) {
                return nil;
            }
            NSUInteger topLimit = MIN(cTopPeers, hostingPeers.count);
            NSUInteger peerIndex = arc4random_uniform(topLimit);
            selectedData = [hostingPeers objectAtIndex:peerIndex];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:cURLStringFormat, selectedData.hostDD4, cHttpPort, selectedData.playlist];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

#pragma mark Utility
+ (void) removeAdvertisementsFromArray:(NSMutableArray *)array olderThan:(NSTimeInterval)limit {
    NSMutableArray *discarded = [NSMutableArray array];
    
    for (HLSStreamAdvertisement *ad in array) {
        NSTimeInterval age = [ad.created timeIntervalSinceNow];
        if (age > limit) {
            [discarded addObject:ad];
        }
    }
    
    [array removeObjectsInArray:discarded];
}

// Note: We are assuming an IPv4 address.
// Ref: http://stackoverflow.com/questions/2327864/converting-nsnetservice-addresses-to-ip-address-string
+ (NSString *) dottedDecimalFromSocketAddress:(NSData *)dataIn {
    struct sockaddr_in *socketAddress = (struct sockaddr_in *)dataIn.bytes;
    
    // We need to convert from network byte order.
    NSString *ipString = [NSString stringWithFormat: @"%s", inet_ntoa(socketAddress->sin_addr)];
    
    return ipString;
}

@end
