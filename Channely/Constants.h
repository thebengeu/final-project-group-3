//
//  Constants.h
//  Channely
//
//  Created by Beng on 16/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

typedef enum {
    kTextMenuItem,
    kPictureMenuItem,
    kVideoMenuItem,
    kGalleryMenuItem
} kAwesomeMenuItems;

static NSString *const kTextCellContentFontName = @"Helvetica Neue";
static const CGFloat kTextCellContentFontSize = 14.0f;
static const CGFloat kTextCellContentMaxWidth = 184.0f; // UITextView has 8px of padding on each side
static const CGFloat kTextCellContentMaxHeight = 500.0f;
static const CGFloat kTextCellContentVerticalMargins = 70.0f;