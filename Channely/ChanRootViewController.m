//
//  ChanRootViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRootViewController.h"

NSString *const cLocalServerLoadKey = @"_lsload";
NSString *const cApplicationTypeName = @"_channely._tcp.";
NSUInteger const cLocalServerPort = 10001;

@interface ChanRootViewController ()
// Internal.
@property (strong) HTTPServer *_localServer;
@property (strong) HLSStreamDiscoveryManager *_discoveryManager;

- (void) setupHttpServer;

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
    
    // Create test file.
    NSURL *file = [NSURL fileURLWithPath:[[ChanUtility documentsDirectory] stringByAppendingPathComponent:@"index.html"]];
    [@"<h1>hello world</h1>" writeToURL:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self setupHttpServer];
    [self setupDiscoveryManager];
}

- (void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Http Server
- (void) setupHttpServer {
    _localServer = [[HTTPServer alloc] init];
    _localServer.port = cLocalServerPort;
    _localServer.documentRoot = [ChanUtility documentsDirectory];
    
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

@end
