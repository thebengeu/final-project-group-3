#import "_ChanTwitterPost.h"

/**
 `ChanTwitterPost` wraps API and persistence operations for Twitter posts.
 */
@interface ChanTwitterPost : _ChanTwitterPost {}

/**
 Canonical url on Twitter.com for the tweet.
 */
@property (readonly) NSString *url;

/**
 Gets tweets with given hashtag.
 
 @param hashtag Twitter hashtag to search for. Should start with '#' and have at least one character following.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an NSArray of the tweets and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)getTweetsWithHashTag:(NSString *)hashtag WithCompletion:(void (^)(NSArray *tweets, NSError *error))block;

@end
