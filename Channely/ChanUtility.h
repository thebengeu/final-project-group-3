//
//  Utility.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ChanUtility : NSObject
+ (NSString *) documentsDirectory;
+ (NSString *) webRootDirectory;
+ (NSString *) videoTempDirectory;
+ (BOOL) createDirectory:(NSString *)directory;
+ (void) clearDirectory:(NSString *)directory;
+ (NSString *) fileNameFromURLString:(NSString *)url;
+ (void) removeItemAtPath:(NSString *)path;
+ (BOOL) directoryExists:(NSString *)directory;

@end
