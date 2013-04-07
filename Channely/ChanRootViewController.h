//
//  ChanRootViewController.h
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTTPServer.h>
#import "HLSStreamDiscoveryManager.h"
#import "HLSStreamAdvertiser.h"
#import "ChanUtility.h"

#import "HLSStreamSync.h"

@interface ChanRootViewController : UINavigationController <HLSStreamAdvertiser>
- (void) setAdvertiserDictionary:(NSDictionary *)dict;

@end
