//
//  ChanAppDelegate.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLSStreamAdvertiser.h"

@interface ChanAppDelegate : UIResponder <UIApplicationDelegate, HLSStreamAdvertiser>
@property (strong, nonatomic) UIWindow *window;

@end
