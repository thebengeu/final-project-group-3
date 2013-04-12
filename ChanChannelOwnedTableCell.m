//
//  ChanChannelOwnedTableCell.m
//  Channely
//
//  Created by k on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanChannelOwnedTableCell.h"
#import "ChanDetailViewController.h"

@implementation ChanChannelOwnedTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)enter:(id)sender {
    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    ChanDetailViewController *detail = [[rootVC childViewControllers]objectAtIndex:0];
    
    [detail startChannel:_channel];
}

@end
