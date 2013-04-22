//
//  ChanAnonUser.m
//  Channely
//
//  Created by k on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAnonUser.h"

@implementation ChanAnonUser

static NSString *anonName = @"Anonymous";

+ (NSString *)name
{
    return anonName;
}

+ (void)setName:(NSString *)name
{
    anonName = name;
}

@end
