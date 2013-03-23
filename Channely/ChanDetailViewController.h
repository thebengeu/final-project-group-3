//
//  ChanDetailViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *discoverSearchToggle;

-(IBAction)changeSeg;

@end
