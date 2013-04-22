//
//  ChannelUITableViewCell.m
//  Channely
//
//  Created by k on 22/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelUITableViewCell.h"

@implementation ChannelUITableViewCell

- (IBAction)locationButtonTapped:(id)sender
{
    [[self delegate]selectMapAnnotationForChannel:self];
}

@end
