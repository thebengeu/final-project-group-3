//
//  ChanRootViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRootViewController.h"

NSString *const cApplicationTypeName = @"_channely._tcp.";
NSUInteger const cLocalServerPort = 10001;

@interface ChanRootViewController ()
// Internal.
@property (strong) HTTPServer *_localServer;

@end

@implementation ChanRootViewController
// Internal.
@synthesize _localServer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _localServer = [[HTTPServer alloc] init];
    _localServer.port = cLocalServerPort;
    _localServer.documentRoot = [ChanUtility documentsDirectory];
    
    // Test dictionary.
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"index.html", @"beng", @"another.html", @"cedric", nil];
    
    _localServer.type = cApplicationTypeName;
    _localServer.TXTRecordDictionary = dict;
    
    // Test file.
    NSURL *file = [NSURL fileURLWithPath:[[ChanUtility documentsDirectory] stringByAppendingPathComponent:@"index.html"]];
    [@"<h1>hello world</h1>" writeToURL:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [_localServer start:nil];
}

- (void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
