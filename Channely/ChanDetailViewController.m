//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"

@implementation ChanDetailViewController

@synthesize homeTabController;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setHomeTabController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabController"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *seg = sender;
    [self switchContainerView: seg.selectedSegmentIndex];
}


- (void) switchContainerView: (NSUInteger)i{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:_container
                             cache:YES];
    [UIView commitAnimations];
    NSLog(@"%d", [homeTabController selectedIndex]);
    [homeTabController setSelectedIndex:i];
    NSLog(@"%d", [homeTabController selectedIndex]);
}

@end
