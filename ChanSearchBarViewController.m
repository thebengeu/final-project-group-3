//
//  ChanSearchBarViewController.m
//  Channely
//
//  Created by Cedric on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanSearchBarViewController.h"

@interface ChanSearchBarViewController ()

@end

@implementation ChanSearchBarViewController

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
    
    [_searchBar becomeFirstResponder];
}

@end
