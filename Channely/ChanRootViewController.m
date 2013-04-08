//
//  ChanRootViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRootViewController.h"

static NSString *const cLocalServerLoadKey = @"_lsload";
static NSString *const cApplicationTypeName = @"_channely._tcp.";
static NSUInteger const cLocalServerPort = 80;
//static NSString *const cHTMLDebugPage = @"<!DOCTYPE html><html><head><title>HLS Example</title></head><body><div><video src=\"prog_index.m3u8\" controls autoplay></video></div></body></html>";

@interface ChanRootViewController ()
// Internal.
@property (strong) HTTPServer *_localServer;
@property (strong) HLSStreamDiscoveryManager *_discoveryManager;

- (void) setupHttpServer;
- (void) setupDiscoveryManager;
- (void) setupDirectories;
- (void) setupStreamSync;

@end

@implementation ChanRootViewController
// Internal.
@synthesize _localServer;
@synthesize _discoveryManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupDirectories];
    
    // DEBUG - Create test file.
//    NSURL *file = [NSURL fileURLWithPath:[[ChanUtility webRootDirectory] stringByAppendingPathComponent:@"index.html"]];
//    [cHTMLDebugPage writeToURL:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self setupHttpServer];
    [self setupDiscoveryManager];
    [self setupStreamSync];
}

- (void) viewDidAppear:(BOOL)animated {
    // DEBUG
//    HLSStreamSync *sync = [HLSStreamSync setupStreamSyncWithBaseDirectory:[ChanUtility webRootDirectory]];
//    [sync syncStreamId:@"prog_index" playlistURL:[NSURL URLWithString:@"http://upthetreehouse.com/images/gear1/prog_index.m3u8"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Http Server
- (void) setupHttpServer {
    _localServer = [[HTTPServer alloc] init];
    _localServer.port = cLocalServerPort;
    _localServer.documentRoot = [ChanUtility webRootDirectory];
    
    _localServer.type = cApplicationTypeName;
    
    [_localServer start:nil];
}

#pragma mark HLS Stream Discovery Manager
- (void) setupDiscoveryManager {
    _discoveryManager = [HLSStreamDiscoveryManager discoveryManagerWithAdvertiser:self];
}

#pragma mark HLS Stream Advertiser Delegate
- (void) setAdvertiserDictionary:(NSDictionary *)dict {
    if (_localServer) {
        NSUInteger load = [_localServer numberOfHTTPConnections] + [_localServer numberOfWebSocketConnections];
        NSMutableDictionary *records = [NSMutableDictionary dictionaryWithDictionary:dict];
        [records setObject:[NSString stringWithFormat:@"%d", load] forKey:cLocalServerLoadKey];
        [_localServer setTXTRecordDictionary:records];
    }
}

#pragma mark Recording Temp Directory
- (void) setupDirectories {
    // Note: this also clears all exisiting files in the web root.
    [ChanUtility createDirectory:[ChanUtility webRootDirectory]];
    
    [ChanUtility createDirectory:[ChanUtility videoTempDirectory]];
}

#pragma mark HLS Stream Sync
- (void) setupStreamSync {
    [HLSStreamSync setupStreamSyncWithBaseDirectory:[ChanUtility webRootDirectory]];
}

@end
