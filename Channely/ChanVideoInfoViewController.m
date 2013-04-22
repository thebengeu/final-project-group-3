//
//  ChanVideoInfoViewController.m
//  Channely
//
//  Created by k on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoInfoViewController.h"

@interface ChanVideoInfoViewController ()

@end

@implementation ChanVideoInfoViewController

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
    
    [_resolution setText:_resolutionText];
    [_recordingId setText:_recordingIdText];
    [_host setText:_hostText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
