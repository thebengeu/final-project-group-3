//
//  ChannelViewController.m
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelViewController.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

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
    NSLog(@"%@", [self channelName]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
