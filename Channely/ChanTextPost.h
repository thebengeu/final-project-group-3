#import "_ChanTextPost.h"

/**
 `ChanTextPost` wraps API and persistence operations for Channely text posts.
 */
@interface ChanTextPost : _ChanTextPost {}

/**
 Deletes text post.

 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the deleted text post and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)deleteWithCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;

@end
