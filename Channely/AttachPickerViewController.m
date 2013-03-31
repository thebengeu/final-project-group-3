//
//  AttachPickerViewController.m
//  Channely
//
//  Created by k on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AttachPickerViewController.h"

@interface AttachPickerViewController ()

@end

@implementation AttachPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)pickImage:(id)sender {
    [_delegate pickImage:sender];
}

- (IBAction)takePhoto:(id)sender {
    [_delegate takePhoto:sender];
}

@end
