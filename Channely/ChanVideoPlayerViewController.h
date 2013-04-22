//
//  ChanVideoPlayerViewController.h
//  Channely
//
//  Created by Camillus Gerard Cai on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;
@protocol ChannelViewControllerDelegate;

@interface ChanVideoPlayerViewController : UIViewController <UIPopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)setServerURL:(NSString *)url forChannel:(ChanChannel *)channel;

@property id<ChannelViewControllerDelegate> delegate;

@end
