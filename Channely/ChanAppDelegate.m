//
//  ChanAppDelegate.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAppDelegate.h"
#import "ChanTwitterPost.h"

static NSString *const _SERVER_ADDR = @"https://upthetreehouse.com:10000";
static NSString *const cLocalServerLoadKey = @"_lsload";
static NSString *const cApplicationTypeName = @"_channely._tcp.";
static NSUInteger const cLocalServerPort = 22;

@interface ChanAppDelegate ()
// Internal.
@property (strong) HTTPServer *_localServer;
@property (strong) HLSStreamAdvertisingManager *_advertisingManager;
@property (strong) HLSPeerDiscovery *_loadBalancer;
@property (strong) HLSStreamSync *_streamSync;

// Appearance.
- (void) customizeAppearance;

@end

@implementation ChanAppDelegate
// Internal.
@synthesize _localServer;
@synthesize _advertisingManager;
@synthesize _loadBalancer;
@synthesize _streamSync;

#pragma mark AppDelegate Methods
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"did finish launching!");
    
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
    
    // Configure a managed object cache to ensure we do not create duplicate objects
//    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
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
    
    // Setup directory structure for recording and serving
    [self setupDirectories];
    
    [self setupHttpServer];
    [self setupAdvertisingManager];
    [self setupStreamSync];
    [self setupPeerDiscovery];
    
    return YES;
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%@", [HLSStreamAdvertisingManager advertisingManager].advertisements);
    [_advertisingManager resumeAdvertising];
    
    // Note: This method might take some time to execute.
    // TODO - Test for edge case where app goes to suspend when stream is downloading, and then resumed.
    [_streamSync recheckExistingStreams];
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%@", [HLSStreamAdvertisingManager advertisingManager].advertisements);
    NSLog(@"went background!");
}

#pragma mark Appearance Customizations 
- (void) customizeAppearance {
    [self customizeNavButtonsAppearance];
    [self customizeNavBarAppearance];
}

- (void) customizeNavBarAppearance
{
    // Create resizable images
    UIImage *gradientImg44 = [[UIImage imageNamed:@"top_gradient_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *gradientImg32 = [[UIImage imageNamed:@"top_gradient_32"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for all UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImg44 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:gradientImg32 forBarMetrics:UIBarMetricsLandscapePhone];
    
    //Set background image for all UIBars
    [[UIToolbar appearance] setBackgroundImage:gradientImg44 forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
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

- (void) customizeNavButtonsAppearance
{
    // Change the appearance of back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 8)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Change the appearance of other navigation buttons
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

#pragma mark Http Server
- (void) setupHttpServer {
    _localServer = [[HTTPServer alloc] init];
    _localServer.port = cLocalServerPort;
    _localServer.documentRoot = [ChanUtility webRootDirectory];
    
    _localServer.type = cApplicationTypeName;
    
    [_localServer start:nil];
}

#pragma mark HLS Stream Advertising Manager
- (void) setupAdvertisingManager {
    _advertisingManager = [HLSStreamAdvertisingManager advertisingManagerWithAdvertiser:self];
}

#pragma mark HLS Stream Advertiser Delegate
- (void) setAdvertiserDictionary:(NSDictionary *)dict {
    if (_localServer) {
        [_localServer setTXTRecordDictionary:dict];
    }
}

- (void) republishBonjour {
    if (_localServer) {
        [_localServer republishBonjour];
    }
}

#pragma mark Recording Temp Directory
- (void) setupDirectories {
    // Note: non-destructive.
    [ChanUtility createDirectory:[ChanUtility webRootDirectory]];
    [ChanUtility createDirectory:[ChanUtility videoTempDirectory]];
}

#pragma mark HLS Stream Sync
- (void) setupStreamSync {
    _streamSync = [HLSStreamSync setupStreamSyncWithBaseDirectory:[ChanUtility webRootDirectory]];
    
    // Note: This method might take some time to execute.
    [_streamSync recheckExistingStreams];
}

#pragma mark HLS Peer Discovery
- (void) setupPeerDiscovery {
    _loadBalancer = [HLSPeerDiscovery setupPeerDiscovery];
}


@end
