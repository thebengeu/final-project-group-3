//
//  ChanRootViewController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanRootViewController.h"

@implementation ChanRootViewController
@synthesize forceLandscape;

#pragma mark View Controller Methods

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (forceLandscape) return UIInterfaceOrientationMaskLandscape;
    else return [super supportedInterfaceOrientations];
}

//#pragma mark UI Navigation View Controller Delegate
//- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [viewController viewDidAppear:animated];
//}
//
//- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [viewController viewWillAppear:animated];
//}

@end
