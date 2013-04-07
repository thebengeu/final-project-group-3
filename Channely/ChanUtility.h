//
//  Utility.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChanUtility : NSObject
+ (NSString *) documentsDirectory;
+ (NSString *) webRootDirectory;
+ (NSString *) videoTempDirectory;
+ (void) createDirectory:(NSString *)directory;
+ (void) clearDirectory:(NSString *)directory;

@end
