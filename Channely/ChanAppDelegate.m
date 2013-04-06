//
//  ChanAppDelegate.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "ChanAppDelegate.h"
#import "ChanMasterViewController.h"
#import "ios-ntp.h"
#import "ChanRestKitObjectMappings.h"
#import "ChanAPIEndpoints.h"

NSString *const _SERVER_ADDR = @"https://upthetreehouse.com:10000";

@implementation ChanAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Channely" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Configure the object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:_SERVER_ADDR]];
    objectManager.managedObjectStore = managedObjectStore;
    [objectManager.HTTPClient setDefaultHeader:@"clientId" value:CLIENT_ID];
    [objectManager.HTTPClient setDefaultHeader:@"clientSecret" value:CLIENT_SECRET];
    
    [RKObjectManager setSharedManager:objectManager];
    
    [ChanRestKitObjectMappings setup];
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    //  Start NTP
    [NetworkClock sharedNetworkClock];

    return YES;
}

@end
