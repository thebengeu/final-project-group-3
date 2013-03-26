//
//  ChanHiddenTabBarController.m
//  Channely
//
//  Created by Camillus Gerard Cai on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanHiddenTabBarController.h"

@interface ChanHiddenTabBarController ()

@end

@implementation ChanHiddenTabBarController
@synthesize tabBar;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void) viewDidAppear:(BOOL)animated {
    // Hide tab bar.
    tabBar.hidden = YES;
    
    // Resize view to full screen.
    // content view (#0), bar view (#1))
    // Ref: http://stackoverflow.com/questions/2426248/uitabbar-leaves-a-white-rectangle-when-hidden
    
    CGRect rect = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        CGFloat temp = rect.size.width;
        rect.size.width = rect.size.height;
        rect.size.height = temp;
    }
    ((UIView *)[self.view.subviews objectAtIndex:0]).frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
