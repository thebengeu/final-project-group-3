//
//  HLSStreamSync.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSPlaylistDownloadOperation.h"
#import "ChanUtility.h"
#import "HLSEventPlaylistHelper.h"
#import "HLSStreamAdvertisingManager.h"
#import "HLSPlaylistDownloadOperationDelegate.h"
#import "Constants.h"

@interface HLSStreamSync : NSObject <HLSPlaylistDownloadOperationDelegate>
- (id) init;
- (NSUInteger) operationCount;
- (void) syncStreamId:(NSString *)sId playlistURL:(NSURL *)playlist;
- (BOOL) completeLocalStreamExistsForStreamId:(NSString *)sId;
- (void) recheckExistingStreams;

+ (HLSStreamSync *) streamSync;
+ (HLSStreamSync *) setupStreamSyncWithBaseDirectory:(NSString *)dir;

@end
