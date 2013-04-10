//
//  Utility.m
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 5/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanUtility.h"

static NSString *const cWebRootDir = @"www";
static NSString *const cVideoTempDir = @"recording";

@implementation ChanUtility
+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *) webRootDirectory {
    return [[ChanUtility documentsDirectory] stringByAppendingPathComponent:cWebRootDir];
}

+ (NSString *) videoTempDirectory {
    return [[ChanUtility documentsDirectory] stringByAppendingPathComponent:cVideoTempDir];
}

+ (void) createDirectory:(NSString *)directory {
    // Create media content directory.
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory) {
        [fm removeItemAtPath:directory error:nil];
    }
    [fm createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
}

// Removes all files from app's documents directory.
// Ref: http://stackoverflow.com/questions/4793278/deleting-all-the-files-in-the-iphone-sandbox-documents-folder
+ (void) clearDirectory:(NSString *)directory {
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    NSArray *files = [fm contentsOfDirectoryAtPath:directory error:&error];
    if (error) {
        NSLog(@"Could not get list of files in document directory.");
        return;
    }
    
    for (NSString *path in files) {
        NSString *fullPath = [directory stringByAppendingPathComponent:path];
        
        BOOL removed = [fm removeItemAtPath:fullPath error:&error];
        if (!removed) {
            NSLog(@"Could not remove file: %@", fullPath);
        }
    }
}

+ (NSString *) fileNameFromURLString:(NSString *)url {
    return [[url lastPathComponent] stringByDeletingPathExtension];
}

@end
