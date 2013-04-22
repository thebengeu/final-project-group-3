//
//  ChanPostViewController.m
//  Channely
//
//  Created by k on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanPostViewController.h"
#import "Constants.h"
#import "ChanChannel.h"
#import "ChanUser.h"
#import "ChanAnonUser.h"

@interface ChanPostViewController ()

@property NSInteger keyboardShown;

@end

@implementation ChanPostViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    self.tapBehindRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    
    [self.tapBehindRecognizer setNumberOfTapsRequired:1];
    self.tapBehindRecognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:self.tapBehindRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    _keyboardShown = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [self.view.window removeGestureRecognizer:self.tapBehindRecognizer];
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            if (_keyboardShown > 0) {
                [[self view] endEditing:YES];
                return;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    _keyboardShown = 1;
}

- (void)keyboardDidHide:(NSNotification *)aNotification
{
    _keyboardShown = 0;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)hideKeyboard
{
    if (_keyboardShown > 0) [[self view] endEditing:YES];
}

- (void)showErrorDialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPostErrorTitle message:kPostErrorMessage delegate:nil cancelButtonTitle:kOkButtonTitle otherButtonTitles:nil];
    [alert show];
    return;
}

@end
