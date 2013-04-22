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
static NSString *const kChanAnnotationVCName = @"ChanAnnotationViewController";
static NSString *const kChanImagePostVC = @"ChanImagePostViewController";
static NSString *const kChanCreateEventVC = @"ChanCreateEventViewController";
static NSString *const kChanSearchTableVC = @"ChanSearchTableViewController";
static NSString *const kChannelVC = @"ChannelViewController";

// Segue
static NSString *const kVideoPlayerSegue = @"videoPlayerSegue";
static NSString *const kSlideSegue = @"slidesSegue";
static NSString *const kTextSegue = @"textSegue";
static NSString *const kImageSegue = @"imageSegue";
static NSString *const kTweetSegue = @"tweetSegue";
static NSString *const kSlideAnnotationSegue = @"SlideAnnotationSegue";
static NSString *const kCollectionViewSegue = @"CollectionViewSegue";
static NSString *const kTakeVideoSegue = @"takeVideoSegue";
static NSString *const kCreateChannelSegue = @"CreateChannelSegue";
static NSString *const kUpdateChannelSegue = @"UpdateChannelSegue";
static NSString *const kDiscoverChannelContainerSegue = @"DiscoverChannelContainerSegue";
static NSString *const kChannelSegue = @"ChannelSegue";
static NSString *const kMenuSegue = @"MenuSegue";

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

// Collection View Cells
static const CGFloat kCellBackgroundImageHeight = 18.0f;

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

// Video Cell
static const CGFloat kVideoCellThumbnailWidth = 80.0f;
static const CGFloat kVideoCellThumbnailHeight = 60.0f;
static const CGFloat kVideoCellThumbnailRightMargin = 1.0f;
static const CGFloat kVideoCellThumbnailBottomMargin = 1.0f;
static const int kVideoCellThumbnailsPerRow = 3;
static const int kVideoCellMaxThumbnails = 120;
static const CGFloat kVideoCellHeaderHeight = 18.0f;

// Annotation View
static const CGFloat kMarkerSize = 3.0f;
static const NSInteger kMarkerMinSegment = 8;
static const NSInteger kMarkerMaxSegment = 32;
static const CGFloat kAnnotationImageMaxSize = 640.0;

//  Discover View Controller
static const NSInteger kDistanceFilterMetres = 10;
static const CGFloat kEventsSearchRadiusInMetres = 1000.0f;

// HTTP Live Streaming Advertisement
static NSUInteger const kCompleteStreamShift = 31; // The right-shift offset for the bit-flag indicating if a stream is complete.
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

// Channel View Controller
static NSString *const kCreateEventButtonTitle = @"Create Event";
static NSString *const kEventCreatedMessage = @"Event created";
static NSString *const kPostPostedMessage = @"Posted";

// Post
static NSString *const kPostErrorTitle = @"Oops";
static NSString *const kPostErrorMessage = @"Error sending post";
static NSString *const kTextPostCustomBackgroundPath = @"custom-dialog-background";
static NSString *const kPostDeletedMessage = @"Post deleted";
static NSString *const kPostDeletionErrorMessage = @"Error deleting post";

//  Alert
static NSString *const kOkButtonTitle = @"Ok";
static NSString *const kCancelButtonTitle = @"Cancel";

// Channel Owned
static NSString *const kChannelOwnedNavigationTitle = @"Channels";
static NSString *const kChannelOwnedTableCell = @"ChanChannelOwnedTableCell";

// Create Channel
static NSString *const kCreateChannelButtonTitle = @"Create";
static NSString *const kCreateChannelNavigationTitle = @"Create Channel";
static NSString *const kCreateChannelEmptyChannelNameAlertTitle = @"Oops";
static NSString *const kCreateChannelEmptyChannelNameAlertMessage = @"Channel Name must not be empty";
static NSString *const kUpdateChannelCompletedMessageFormat = @"Updated %@";
static NSString *const kCreateChannelCompletedMessageFormat = @"Created %@";
static NSString *const kDeleteChannelCompletedMessageFormat = @"Deleted %@";

// Create Event
static NSString *const kDateFormat = @"dd/MM/yyyy hh:mm a";
static NSString *const kCreateEventDescriptionPlaceholder = @"Description";
static NSString *const kSelectedMapAnnotationTitle = @"Selection";
static NSString *const kCreateEventAlertTitle = @"Create Event";
static NSString *const kCreateEventInvalidTitleMessage = @"Please enter an event name.";
static NSString *const kCreateEventInvalidDateMessage = @"Invalid dates.";

//  Discover View Controller
static NSString *const kMyLocationMapAnnotation = @"MyLocation";
static NSString *const kChannelLocationMapAnnotation = @"ChannelLocation";

// ChanDetail View Controller
static NSString *const kSearchBarPlaceholder = @"Search Channely";

// Errors
static NSString *const kOverrideClassMessage = @"You must override %@ in a subclass";
static NSString *const kUnexpectedTypeConstantMessage = @"Unexpected type constant %d";

// User Menu
static NSString *const kUserMenuLoginAlertTitle = @"Login";
static NSString *const kUserMenuLoginErrorTitle = @"Error while logging in";
static NSString *const kUserMenuSignupAlertTitle = @"Signup";
static NSString *const kUserMenuAlertInvalidUsernamePasswordMessage = @"Invalid Username or Password";
static NSString *const kUserMenuUpdateAlertTitle = @"Update";
static NSString *const kUserMenuUpdateInvalidUsernameMessage = @"Invalid username";
