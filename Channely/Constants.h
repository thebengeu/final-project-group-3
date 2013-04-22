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

typedef enum {
    kTextPost,
    kImagePost,
    kVideoPost,
    kVideoThumbnailPost,
    kSlidesPost,
    kSlidePost,
    kTwitterPost
} ChanPostType;

// Server
static NSString *const kServerAddress = @"https://upthetreehouse.com:10000";
static NSString *const kBonjourDomain = @"local.";
static NSString *const kAppServiceName = @"_channely._tcp.";
static NSUInteger const kLocalServerPort = 22;

// Storyboard
static NSString *const kStoryboardName = @"MainStoryboard_iPad";
static NSString *const kMenuUserVCName = @"ChanMenuUserViewController";

// Segue
static NSString *const kVideoPlayerSegue = @"videoPlayerSegue";
static NSString *const kSlideSegue = @"slidesSegue";
static NSString *const kTextSegue = @"textSegue";
static NSString *const kImageSegue = @"imageSegue";
static NSString *const kTweetSegue = @"tweetSegue";
static NSString *const kSlideAnnotationSegue = @"SlideAnnotationSegue";

// Collection View
static CGFloat const kCellWidth = 240.0f;

// Refresh Intervals
static CGFloat const kPostsRefreshIntervalSecs = 10.0f;
static NSUInteger const kTwitterRefreshIntervalSecs = 60;

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

//  Discover View Controller
static const NSInteger kDistanceFilterMetres = 10;

// HTTP Live Streaming Advertisement
static NSUInteger kCompleteStreamShift = 31; // The right-shift offset for the bit-flag indicating if a stream is complete.
static NSUInteger const kCompleteRecordingBitMask = 0x80000000; // Duplicated constant in HLSLoadBalancer.m
static NSUInteger const kTotalChunksBitMask = 0x7FFFFFFF;

// HTTP Live Streaming Local Stream Copy
static NSString *const kDebugPageMarkup = @"<!DOCTYPE html><html><head><title>Local Stream View</title></head><body><div><video src=\"%@.m3u8\" controls autoplay></video></div></body></html>";
static NSString *const kDebugPageName = @"view.html";

// Stream Persistence
static NSTimeInterval const kMaxStreamAge = 1209600; // Seconds. 14 days.

// Peer Discovery
static NSTimeInterval const kNetServiceResolveTimeout = 5.0; // Seconds.

// P2P Distribution
static NSUInteger const kMaxSpreadRadius = 5;

// Chunking Video Recorder
static NSString *const kOutputFilePathFormat = @"%@/chunk%d.mp4";

// Directories
static NSString *const kWebRootDir = @"www";
static NSString *const kVideoTempDir = @"recording";

// NSOperation
static NSString *const kKVOIsExecuting = @"isExecuting";
static NSString *const kKVOIsFinished = @"isFinished";

// NSOperationQueue
static NSString *const kKVOOperation = @"operations";

// Search
static NSString *const kSearchChannelCell = @"ChannelCell";
static NSString *const kSearchEventCell = @"EventCell";
static NSString *const kSearchChannelSectionName = @"Channels";
static NSString *const kSearchEventSectionName = @"Events";