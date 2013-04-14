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

// Non-destructively creates a directory. If the directory exists, no action is taken.
// Returns YES if a directory was created, NO if no action was taken.
+ (BOOL) createDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (!([fm fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory)) {
        [fm createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
        return YES;
    }
    return NO;
}

+ (void) removeDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory) {
        [fm removeItemAtPath:directory error:nil];
    }
}

// Removes all files from app's documents directory.
// Ref: http://stackoverflow.com/questions/4793278/deleting-all-the-files-in-the-iphone-sandbox-documents-folder
+ (void) clearDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
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

+ (void) removeFileAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    [fm removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"Could not remove %@.", path);
    }
}

@end
