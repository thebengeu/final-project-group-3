//
//  HLSStreamSync.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSStreamSync : NSObject
- (id) init;
- (NSUInteger) operationCount;
- (void) syncStreamId:(NSString *)sId playlistURL:(NSURL *)playlist;

+ (HLSStreamSync *) streamSync;
+ (HLSStreamSync *) setupStreamSyncWithBaseDirectory:(NSString *)dir;

@end
