//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"

@implementation ChanDetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setDiscoverViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DiscoverViewController"]];
    [self setSearchViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_container addSubview: [_discoverViewController view]];
    [_container addSubview:[_searchViewController view]];
    [[_discoverViewController view] setFrame:_container.frame];
    [self switchContainerView:[[self discoverViewController]view]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *seg = sender;
    if (seg.selectedSegmentIndex == 0)
        [self switchContainerView:[[self discoverViewController]view]];
    else if (seg.selectedSegmentIndex == 1)
        [self switchContainerView:[[self searchViewController]view]];
}


- (void) switchContainerView: (UIView*)view{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:view
                             cache:YES];
    [UIView commitAnimations];
    
    for (UIView *v in [_container subviews])
        [v setHidden:YES];
    
    [view setHidden:NO];
}

@end
