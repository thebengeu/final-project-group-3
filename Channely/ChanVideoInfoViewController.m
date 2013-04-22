//
//  ChanVideoInfoViewController.m
//  Channely
//
//  Created by k on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanVideoInfoViewController.h"

@implementation ChanVideoInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_resolution setText:_resolutionText];
    [_recordingId setText:_recordingIdText];
    [_host setText:_hostText];
}

@end
