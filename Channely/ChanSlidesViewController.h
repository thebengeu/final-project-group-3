//
//  ChanSlidesViewController.h
//  Channely
//
//  Created by Beng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanChannel;
@class ChanSlidesPost;

@interface ChanSlidesViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UIImageView *imageView3;

@property (strong, nonatomic) ChanChannel *channel;
@property (strong, nonatomic) ChanSlidesPost *post;
@property (strong, nonatomic) NSArray *slides;
@property CGFloat pageWidth;

- (IBAction)backButton_Action:(id)sender;

@end
