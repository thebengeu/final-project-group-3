#import "_ChanChannel.h"

@class ChanTextPost;
@class ChanImagePost;

@interface ChanChannel : _ChanChannel {}

- (void)getPostsWithCompletion:(void (^)(NSArray *posts, NSError *error))block;
- (void)addTextPostWithContent:(NSString *)content
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;
- (void)addImagePostWithContent:(NSString *)content
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;
@end
