//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"

@interface ChanDetailViewController ()
@property (strong) UITabBarController *_homeTabController;

- (void) hideTabBar;

@end

@implementation ChanDetailViewController
@synthesize _homeTabController;

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (IBAction) segmentChanged:(UISegmentedControl *)sender {
    [self switchContainerView: sender.selectedSegmentIndex];
}

- (void) hideTabBar {
    if (!_homeTabController) {
        NSLog(@"_homeTabController still null!");
    }
    
    // TODO:
    
}


- (void) switchContainerView: (NSUInteger)index{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_container cache:YES];
    [UIView commitAnimations];
    _homeTabController.selectedIndex = index;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embeddedTabBarSegue"]) {
        self._homeTabController = (UITabBarController *)segue.destinationViewController;
    }
}


@end
