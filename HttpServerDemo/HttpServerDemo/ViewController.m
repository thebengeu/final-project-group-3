//
//  ViewController.m
//  HttpServerDemo
//
//  Created by k on 12/3/13.
//  Copyright (c) 2013 k. All rights reserved.
//

#import "ViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize httpServer = _httpServer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //  Show ip and host  
    [self setText:[[UITextView alloc]initWithFrame:[self view].frame]];
    [[self view]addSubview:[self text]];
    [[self text]setText:[[self GetOurIpAddress] stringByAppendingString:@":12345"]];
    
    [self setupHTTP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupHTTP
{
	// Initalize our http server
	_httpServer = [[HTTPServer alloc] init];
    
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[_httpServer setType:@"_http._tcp."];
    
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [_httpServer setPort:12345];
    
	// Serve files from the standard Sites folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docRoot = [@"~/Documents/Sites" stringByExpandingTildeInPath];
    NSString *docRoot2 = [NSString stringWithFormat:@"%@/", docRoot];

    NSString *index = [NSString stringWithFormat:@"%@/index.html", docRoot];
    [fileManager removeItemAtPath:index error:nil];
    //BOOL isDirectory;
/*
    if (![[NSFileManager defaultManager] fileExistsAtPath:docRoot2 isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] createDirectoryAtPath:docRoot2
                                  withIntermediateDirectories:YES
                                                   attributes:attr
                                                        error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
  */  
    NSError *error;
    if (![@"Hello channely!" writeToFile:index atomically:YES encoding:NSUTF8StringEncoding error:&error])
        NSLog(@"Error writing file %@", error);
    
	NSLog(@"Setting document root: %@", docRoot);
    
	[_httpServer setDocumentRoot:docRoot];
    
	if(![_httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}


// Get IP Address
- (NSString *)GetOurIpAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



@end
