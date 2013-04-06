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

@end

@implementation HLSStreamDiscoveryManager
@synthesize _advertiser;
@synthesize _advertisements;

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

- (void) isAdvertisingRecordingId:(NSString *)rId {
    // TODO:
    
    [self pushAdvertisements];
}

- (void) stopAdvertisingRecordingId:(NSString *)rId {
    // TODO:
    
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
