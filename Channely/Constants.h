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

// Segue
static NSString *const cVideoPlayerSegue = @"videoPlayerSegue";
static NSString *const cSlideSegue = @"slidesSegue";
static NSString *const cTextSegue = @"textSegue";
static NSString *const cImageSegue = @"imageSegue";
static NSString *const cTweetSegue = @"tweetSegue";

// Collection View
static CGFloat const kCellWidth = 240.0f;

// Post Menu
static CGFloat const kPostMenuLandscapeX = 955.0f;
static CGFloat const kPostMenuLandscapeY = 645.0f;
static CGFloat const kPostMenuPortraitX = 700.0f;
static CGFloat const kPostMenuPortraitY = 900.0f;

// Text Cell
static NSString *const kTextCellContentFontName = @"Helvetica Neue";
static const CGFloat kTextCellContentFontSize = 14.0f;
static const CGFloat kTextCellContentMaxWidth = 184.0f; // UITextView has 8px of padding on each side
static const CGFloat kTextCellContentMaxHeight = 500.0f;
static const CGFloat kTextCellContentVerticalMargins = 70.0f;

// Image Cell
static const CGFloat kImageCellThumbnailWidth = kCellWidth;
static const CGFloat kImageCellThumbnailVerticalMargins = 40.0f;

// Slides Cell
static const CGFloat kSlidesCellThumbnailVerticalMargins = kImageCellThumbnailVerticalMargins;
static const CGFloat kSlidesCellDefaultHeight = 260.0f;

// Annotation View
static const CGFloat kMarkerSize = 3.0f;
static const NSInteger kMarkerMinSegment = 8;
static const NSInteger kMarkerMaxSegment = 32;
