//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"

NSString *const cTabBarSegueIdentifier = @"embeddedTabBarSegue";
NSString *const cMenuSegueIdentifier = @"popoverMenuSegue";
CGFloat const cMenuPopoverWidth = 341.;
CGFloat const cMaxMenuPopoverHeight = 704.;

@interface ChanDetailViewController ()
@property (strong) UITabBarController *_homeTabController;
@property (weak) UIPopoverController *_menuSegue;

- (CGSize) calcMenuPopoverSize;

@end

@implementation ChanDetailViewController
@synthesize _homeTabController;
@synthesize _menuSegue;

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

- (void) switchContainerView: (NSUInteger)index{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:_container cache:YES];
    [UIView commitAnimations];
    _homeTabController.selectedIndex = index;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:cTabBarSegueIdentifier]) {
        self._homeTabController = (UITabBarController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:cMenuSegueIdentifier]) {
        _menuSegue = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuSegue.popoverContentSize = [self calcMenuPopoverSize];
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:cTabBarSegueIdentifier]) {
        return YES;
    } else if ([identifier isEqualToString:cMenuSegueIdentifier]) {
        return (_menuSegue == nil);
    } else {
        return YES;
    }
}

- (CGSize) calcMenuPopoverSize {
    CGFloat height = MIN(self.view.bounds.size.height, cMaxMenuPopoverHeight);    
    return CGSizeMake(cMenuPopoverWidth, height);
}

@end
