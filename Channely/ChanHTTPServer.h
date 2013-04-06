//
//  ChanHTTPServer.h
//  Channely
//
//  Created by k on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/*  Sample: ChanHTTPServer *server = [[ChanHTTPServer alloc]initWithWebRootName:@"videoId"]
 *  [server start];
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ChanHTTPServer : NSObject

@property (readonly) NSString *webRootPath;

-(id) initWithWebRootName:(NSString*)webRootName;

-(void) startServer;

-(void) stopServer;

-(NSString*) ipAddress;

@end
