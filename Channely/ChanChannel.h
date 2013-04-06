#import "_ChanChannel.h"

@class ChanTextPost;
@class ChanImagePost;

@interface ChanChannel : _ChanChannel {}

+ (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block;
+ (void)addChannelWithName:(NSString *)name withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;
- (void)getPostsSince:(NSDate *)since
                until:(NSDate *)until
       withCompletion:(void (^)(NSArray *posts, NSError *error))block;
- (void)addTextPostWithContent:(NSString *)content
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;
- (void)addImagePostWithContent:(NSString *)content
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;
@end
