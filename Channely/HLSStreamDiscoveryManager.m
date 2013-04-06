//
//  HLSStreamDiscoveryManager.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamDiscoveryManager.h"

@interface HLSStreamDiscoveryManager ()
@property (strong) NSMutableDictionary *_advertisements;
@property (weak) id<HLSStreamAdvertiser> _advertiser;

- (void) pushAdvertisements;
- (id) initWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser;

@end

@implementation HLSStreamDiscoveryManager
static HLSStreamDiscoveryManager *_internal;

@synthesize _advertiser;
@synthesize _advertisements;

#pragma mark Singleton
- (id) init {
    return nil;
}

+ (HLSStreamDiscoveryManager *) discoveryManager {
    return _internal;
}

+ (HLSStreamDiscoveryManager *) discoveryManagerWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser {
    if (!_internal) {
        _internal = [[HLSStreamDiscoveryManager alloc] initWithAdvertiser:advertiser];
        return _internal;
    } else {
        return nil;
    }
}

#pragma mark Constructors
- (id) initWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser {
    if (self = [super init]) {
        _advertiser = advertiser;
        _advertisements = [NSMutableDictionary dictionary];
        [self pushAdvertisements];
    }
    return self;
}

#pragma mark External Logic
- (void) startAdvertisingPlaylist:(NSString *)playlist asRecordingId:(NSString *)rId {
    NSString *obj = [_advertisements objectForKey:(NSString *)rId];
    if (!obj) {
        [_advertisements setObject:(NSString *)playlist forKey:(NSString *)rId];
    }
    
    [self pushAdvertisements];
}

- (BOOL) isAdvertisingRecordingId:(NSString *)rId {
    NSString *obj = [_advertisements objectForKey:(NSString *)rId];
    return (obj != nil);
}

- (void) stopAdvertisingRecordingId:(NSString *)rId {
    NSString *obj = [_advertisements objectForKey:(NSString *)rId];
    if (obj) {
        [_advertisements removeObjectForKey:(NSString *)rId];
    }
    
    [self pushAdvertisements];
}

- (void) stopAdvertising {
    _advertisements = [NSMutableDictionary dictionary];
    
    [self pushAdvertisements];
}

#pragma mark Internal Logic
- (void) pushAdvertisements {
    if (_advertiser) {
        [_advertiser setAdvertiserDictionary:self.advertisements];
    }
}

#pragma mark Manual Accessors/Mutators
- (NSDictionary *) advertisements {
    return _advertisements;
}

@end
