//
//  HLSStreamDiscoveryManager.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSStreamAdvertisingManager.h"

@interface HLSStreamAdvertisingManager ()
@property (strong) NSMutableDictionary *_advertisements;
@property (weak) id<HLSStreamAdvertiser> _advertiser;

- (void) pushAdvertisements;
- (id) initWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser;

@end

@implementation HLSStreamAdvertisingManager
static HLSStreamAdvertisingManager *_internal;

@synthesize _advertiser;
@synthesize _advertisements;

#pragma mark Singleton
- (id) init {
    return nil;
}

+ (HLSStreamAdvertisingManager *) advertisingManager {
    return _internal;
}

+ (HLSStreamAdvertisingManager *) advertisingManagerWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser {
    if (!_internal) {
        _internal = [[HLSStreamAdvertisingManager alloc] initWithAdvertiser:advertiser];
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
- (void) updateAdvertisementForPlaylist:(NSString *)playlist asRecordingId:(NSString *)rId withChunkCount:(NSUInteger)count {
    NSString *obj = [_advertisements objectForKey:(NSString *)rId];
    
    if (obj) {
        [_advertisements removeObjectForKey:(NSString *)rId];
    }
    
    NSString *packedAd = [HLSStreamAdvertisement packAdvertisementForChunkCount:count playlist:playlist];
    [_advertisements setObject:packedAd forKey:rId];
    
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
