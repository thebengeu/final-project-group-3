//
//  Utility.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSUtility : NSObject
+ (NSString *) documentsDirectory;
+ (void) clearDirectory:(NSString *)directory;

@end
