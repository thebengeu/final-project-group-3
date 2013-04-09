//
//  ChanPeerSelection.m
//  Channely
//
//  Created by k on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPeerSelection.h"
#include <arpa/inet.h>

@interface ChanPeerSelection()

@property NSNetServiceBrowser *browser;

@property NSString *serviceName;

@property NSString *domain;

@property NSMutableArray *foundServices;

@property NSMutableArray *foundServer;

@property NSMutableArray *foundServerLoad;

@property NSTimer *checkTimer;

@property NSString *rId;

@end



@implementation ChanPeerSelection

- (void) selectBestPeerForRecordingId:(NSString *) rId{
    if (rId == nil || [rId length] == 0)
        return;
    
    
    if (_browser == nil){
        _serviceName = @"channely";
        _domain = @"local.";
        _browser = [[NSNetServiceBrowser alloc] init];
        _browser.delegate = self;
    }
    [_browser stop];
    
    _rId = rId;
    _foundServer = [[NSMutableArray alloc]init];
    _foundServices = [[NSMutableArray alloc]init];
    _foundServerLoad = [[NSMutableArray alloc]init];
    
    [_browser searchForServicesOfType:[NSString stringWithFormat:@"_%@._tcp.", _serviceName]
                             inDomain:_domain];
    
    //  Set thread to check found services
    _checkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkResults) userInfo:nil repeats:YES];
}

- (void)checkResults{
    NSInteger lowestLoad = 100000000;
    NSString *bestServer = nil;
    for (int i = 0; i < [_foundServer count]; i++){
        if ([[_foundServerLoad objectAtIndex:i]integerValue] < lowestLoad){
            lowestLoad = [[_foundServerLoad objectAtIndex:i]integerValue];
            bestServer = [_foundServer objectAtIndex:i];
        }
    }
    if (lowestLoad != 100000000){
        [[self delegate]selectedBestPeerForRecordingId: [NSURL URLWithString:bestServer]];
        [_checkTimer invalidate];
        _checkTimer = nil;
    }
}


//  Net browser delegate methods
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
    [netService setDelegate:self];
    [netService resolveWithTimeout:5];
    [_foundServices addObject:netService];
}


-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    for (NSData *addressData in [sender addresses]){
        NSString *address = [self getStringFromAddressData:addressData];
        if ([address compare:@"0.0.0.0"] != NSOrderedSame){
            NSDictionary *result = [NSNetService dictionaryFromTXTRecordData:[sender TXTRecordData]];
            
            //  If contain rId, add to foundServer and foundServerLoad
            if ([result objectForKey:_rId] != nil){
                NSData *dataPath = [result valueForKey:_rId];
                NSString *playlistPath = [[NSString alloc] initWithData:dataPath encoding:NSUTF8StringEncoding];
                [_foundServer addObject:[NSString stringWithFormat:@"http://%@/%@", address, playlistPath]];
                
                NSData *dataLoad = [result valueForKey:@"_lsload"];
                NSString *load = [[NSString alloc] initWithData:dataLoad encoding:NSUTF8StringEncoding];
                [_foundServerLoad addObject:load];
            }
        }
    }
}




- (NSString *)getStringFromAddressData:(NSData *)dataIn {
    struct sockaddr_in  *socketAddress = nil;
    NSString            *ipString = nil;
    
    socketAddress = (struct sockaddr_in *)[dataIn bytes];
    ipString = [NSString stringWithFormat: @"%s",
                inet_ntoa(socketAddress->sin_addr)];  ///problem here
    return ipString;
}

@end
