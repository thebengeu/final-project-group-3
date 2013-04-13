//
//  ChanAppDelegate.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <HTTPServer.h>
#import "NetworkTimeProtocol.h"
#import "ChanRestKitObjectMappings.h"
#import "ChanAPIEndpoints.h"
#import "HLSStreamAdvertisingManager.h"
#import "HLSStreamAdvertiser.h"
#import "ChanUtility.h"
#import "HLSStreamSync.h"
#import "HLSLoadBalancer.h"

@interface ChanAppDelegate : UIResponder <UIApplicationDelegate, HLSStreamAdvertiser>
@property (strong, nonatomic) UIWindow *window;

@end
