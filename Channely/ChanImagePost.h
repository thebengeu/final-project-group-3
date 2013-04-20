#import "_ChanImagePost.h"

@interface ChanImagePost : _ChanImagePost {}

@property (readonly) CGFloat thumbWidth;
@property (readonly) CGFloat thumbHeight;

- (void)deleteWithCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;

@end
