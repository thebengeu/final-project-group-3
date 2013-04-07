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

// Method to customize appearance 
- (void)customizeAppearance {
    // Create resizable images
    UIImage *gradientImg44 = [[UIImage imageNamed:@"top_gradient_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImg32 = [[UIImage imageNamed:@"top_gradient_32"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for all UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImg44 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImg32 forBarMetrics:UIBarMetricsLandscapePhone];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Avenir" size:0.0],
      UITextAttributeFont,
      nil]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set UI customizations
    [self customizeAppearance];
    
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
