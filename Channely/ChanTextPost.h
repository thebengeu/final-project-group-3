#import "_ChanTextPost.h"

@interface ChanTextPost : _ChanTextPost {}

- (void)deleteWithCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;

@end
