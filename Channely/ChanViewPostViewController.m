//
//  ChanViewPostViewController.m
//  Channely
//
//  Created by k on 20/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanViewPostViewController.h"

@interface ChanViewPostViewController ()

@end


@implementation ChanViewPostViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    self.tapBehindRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    
    [self.tapBehindRecognizer setNumberOfTapsRequired:1];
    self.tapBehindRecognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:self.tapBehindRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view.window removeGestureRecognizer:self.tapBehindRecognizer];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
