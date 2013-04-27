#import "_ChanPost.h"
#import "Constants.h"

/**
 `ChanPost` wraps API and persistence operations for Channely posts.
 */
@interface ChanPost : _ChanPost {}

/**
 A ChanPostType constant indicating the type of post.
 
 @exception NSInternalInconsistencyException Raised if getter is not overridden in a subclass.
 */
@property (readonly) ChanPostType typeConstant;

@end
