#import "_ChanImagePost.h"

/**
 `ChanImagePost` wraps API and persistence operations for Channely image posts.
 */
@interface ChanImagePost : _ChanImagePost {}

/**
 Thumbnail width.
 */
@property (readonly) CGFloat thumbWidth;

/**
 Thumbnail height, calculated to have same aspect ratio as full image.
 */
@property (readonly) CGFloat thumbHeight;

/**
 Deletes image post.
 
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the deleted image post and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)deleteWithCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;

@end
