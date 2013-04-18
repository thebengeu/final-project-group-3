//
//  ChanVideoInfoViewController.h
//  Channely
//
//  Created by k on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanVideoInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *resolution;

@property (strong, nonatomic) IBOutlet UITextField *host;

@property (strong, nonatomic) IBOutlet UITextField *recordingId;

@property NSString *resolutionText;

@property NSString *hostText;

@property NSString *recordingIdText;

@end
