//
//  ChanRootViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRootViewController.h"

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
    _localServer.port = 10001;
    _localServer.documentRoot = [HLSUtility documentsDirectory];
    
    // Test dictionary.
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"index.html", @"beng", @"another.html", @"cedric", nil];
    
    _localServer.type = @"_channely._tcp.";
    _localServer.TXTRecordDictionary = dict;
    
    // Test file.
    NSURL *file = [NSURL fileURLWithPath:[[HLSUtility documentsDirectory] stringByAppendingPathComponent:@"index.html"]];
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
