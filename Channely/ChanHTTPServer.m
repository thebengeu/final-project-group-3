//
//  ChanHTTPServer.m
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanHTTPServer.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "HTTPServer.h"

@interface ChanHTTPServer()

@property HTTPServer *httpServer;

@property NSString *webRootPath;

@end

@implementation ChanHTTPServer

-(id) initWithWebRootName:(NSString *)webRootName{
    self = [super init];
    
    if (self){
        //  Create directory
        NSString *docRoot = [@"~/Documents/Sites" stringByExpandingTildeInPath];
        _webRootPath = [docRoot stringByAppendingString:[NSString stringWithFormat:@"/%@", webRootName]];
        [self checkOrCreateDirectory:_webRootPath];
        
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

        //  Delete and recreate index html
        NSString *index = [NSString stringWithFormat:@"%@/index.html", _webRootPath];
        [fileManager removeItemAtPath:index error:nil];
        NSError *error;
        if (![@"Hello channely!" writeToFile:index atomically:YES encoding:NSUTF8StringEncoding error:&error])
            NSLog(@"Error writing file %@", error);
        
        [_httpServer setDocumentRoot:_webRootPath];
    }
    
    return self;
}

-(void) startServer{
    NSError *error;
	if(![_httpServer start:&error])
		NSLog(@"Error starting HTTP Server: %@", error);
}

-(void) stopServer{
    [_httpServer stop];
}

-(NSString*) ipAddress{
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

-(void) checkOrCreateDirectory: (NSString*)directoryPath{
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory] || !isDirectory) {
    NSError *error = nil;
    NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                              withIntermediateDirectories:YES
                                               attributes:attr
                                                    error:&error];
     if (error)
         NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
}

@end
