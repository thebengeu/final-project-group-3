//
//  ChanDetailViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"
#import "SearchViewController.h"

@interface ChanDetailViewController : UIViewController <UITabBarDelegate>
@property (strong, nonatomic) IBOutlet UIView *container;

- (IBAction)segmentChanged:(id)sender;

@end
