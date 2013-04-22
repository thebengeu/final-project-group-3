//
//  AHAlertView+Channely.m
//  Channely
//
//  Created by Beng on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AHAlertView+Channely.h"
#import "Constants.h"

@implementation AHAlertView (Channely)

+ (void)showTumbleAlertWithTitle:(NSString *)title message:(NSString *)message
{
    AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:message];
    __weak AHAlertView *weakA = alert;
    [alert setCancelButtonTitle:kOkButtonTitle block:^{
        weakA.dismissalStyle = AHAlertViewDismissalStyleTumble;
    }];
    [alert show];
}
    
@end
