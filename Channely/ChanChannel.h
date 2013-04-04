#import "_ChanChannel.h"

@class ChanTextPost;
@class ChanImagePost;

@interface ChanChannel : _ChanChannel {}

+ (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block;
+ (void)addChannel:(ChanChannel *)channel withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;
- (void)getPostsWithCompletion:(void (^)(NSArray *posts, NSError *error))block;
- (void)addTextPostWithContent:(NSString *)content
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;
- (void)addImagePostWithContent:(NSString *)content
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;
@end
