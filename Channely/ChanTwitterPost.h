#import "_ChanTwitterPost.h"

@interface ChanTwitterPost : _ChanTwitterPost {}

@property (readonly) NSString* url;

+ (void)getTweetsWithHashTag:(NSString *)hashtag WithCompletion:(void (^)(NSArray *tweets, NSError *error))block;

@end
