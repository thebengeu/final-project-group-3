#import "_ChanImagePost.h"

@interface ChanImagePost : _ChanImagePost {}

- (void)deleteWithCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;

@end
