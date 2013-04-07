//
//  UITextViewField.h
//  Channely
//
//  Created by k on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewField : UITextView <UITextViewDelegate>

@property (assign) NSString *placeholder;

@property (assign) UIColor *placeholderColor;

@end
