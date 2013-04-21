//
//  ChanNavigationControlManager.m
//  Channely
//
//  Created by Camillus Gerard Cai on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanNavigationControlManager.h"

@interface ChanNavigationControlManager ()
// Singleton
- (id) _init;

@end

@implementation ChanNavigationControlManager
static ChanNavigationControlManager *_internal;

#pragma mark Singleton
- (id) init {
    return nil;
}

- (id) _init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (ChanNavigationControlManager *) instance {
    if (!_internal) {
        _internal = [[ChanNavigationControlManager alloc] _init];
        NSLog(@"navigation manager initialized");
    }
    
    return _internal;
}

#pragma mark UI Navigation View Controller Delegate
- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidAppear:animated];
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
}

@end
