//
//  HLSStreamDiscoveryManager.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSStreamAdvertiser.h"
#import "HLSStreamAdvertisement.h"

/**
 `HLSStreamAdvertisingManager` is a component that runs in the background and allows other parts of the application to manage the streams that the current device advertises over Bonjour.
 */
@interface HLSStreamAdvertisingManager : NSObject
@property (readonly) NSDictionary *advertisements;

/**
 Returns `nil`. `HLSStreamSync` is a singleton.
 
 @return `nil`.
 */
- (id)init;

/**
 Advertises a stream. If the specified recording is already being advertised, its parameters are updated with new information. Otherwise, the specified recording starts being published.
 
 @param playlist The path of the playlist on the current device, relative to its host name.
 @param rId The recording id to advertise.
 @param count The number of chunks the current device has associated with the specified recording id.
 */
- (void)updateAdvertisementForPlaylist:(NSString *)playlist asRecordingId:(NSString *)rId withChunkCount:(NSUInteger)count;

/**
 Queries the advertiser and checks if the specified recording is currently being advertised.
 
 @param rId The recording id to query.
 
 @return `YES` if the recording is being advertised, `NO` otherwise.
 */
- (BOOL)isAdvertisingRecordingId:(NSString *)rId;

/**
 Instructs the advertiser to stop publishing information for a recording.
 
 @param rId The recording id to cease advertising.
 */
- (void)stopAdvertisingRecordingId:(NSString *)rId;

/**
 Instructs the advertiser to continue advertising all records it has.
 */
- (void)resumeAdvertising;

/**
 Instructs the advertiser to cease advertising all records it has.
 */
- (void)stopAdvertising;


/**
 Returns a reference to an existing copy of `HLSAdvertisingManager`. If no such copy exists, returns `nil`.
 
 @return An initialized instance of this object, or `nil`.
 */
+ (HLSStreamAdvertisingManager *)advertisingManager;

/**
 Initializes a single instance of `HLSStreamSync` and returns a reference to it. If the object has already been initialized, then this method returns a reference to the existing copy.
 
 @return An initialized instance of this object.
 */
+ (HLSStreamAdvertisingManager *)advertisingManagerWithAdvertiser:(id<HLSStreamAdvertiser>)advertiser;

@end
