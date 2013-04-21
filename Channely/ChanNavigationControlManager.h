//
//  ChanNavigationControlManager.h
//  Channely
//
//  Created by Camillus Gerard Cai on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChanNavigationControlManager : NSObject <UINavigationControllerDelegate>
- (id) init;
- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

+ (ChanNavigationControlManager *) instance;

@end
