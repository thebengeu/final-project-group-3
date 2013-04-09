//
//  AttachPickerViewController.m
//  Channely
//
//  Created by k on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AttachPickerViewController.h"

static NSString *const cTakeVideoSegue = @"takeVideoSegue"; 

@interface AttachPickerViewController ()

@end

@implementation AttachPickerViewController
#pragma mark View Controller Methods
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:cTakeVideoSegue]) {
        ChanVideoCaptureViewController *destination = segue.destinationViewController;
        
        destination.parentChannel = [_delegate underlyingChannel];
    }
}

#pragma mark UI Event Handlers
- (IBAction) pickImage:(id)sender {
    [_delegate pickImage:sender];
}

- (IBAction) takePhoto:(id)sender {
    [_delegate takePhoto:sender];
}

- (IBAction) pickVideo:(id)sender {
    [_delegate pickVideo:sender];
}

@end
