//
//  UITextViewField.m
//  Channely
//
//  Created by k on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UITextViewField.h"
#import <QuartzCore/QuartzCore.h>

@interface UITextViewField()

@property UIColor *userTextColor;

@end


@implementation UITextViewField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.delegate = self;
        
        _userTextColor = [self textColor];
        
        [self setText:_placeholder];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    return self;
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([[self text]compare:_placeholder] == NSOrderedSame){
        [self setText:@""];
        [self setTextColor:_userTextColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([[self text]length] == 0){
        [self setText:_placeholder];
        
        _userTextColor = [self textColor];
        [self setTextColor:_placeholderColor];
    }
}

@end