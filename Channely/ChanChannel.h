#import "_ChanChannel.h"
#import <MapKit/MapKit.h>

@class ChanTextPost;
@class ChanImagePost;

@interface ChanChannel : _ChanChannel {}

+ (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block;
+ (void)addChannelWithName:(NSString *)name hashTag:(NSString *)hashTag withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;
+ (void)search:(NSString *)name withCompletion:(void (^)(NSArray *channels, NSError *error))block;

- (void)updateChannelWithName:(NSString *)name hashTag:(NSString *)hashTag withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;
- (void)getPostsSince:(NSDate *)since
                until:(NSDate *)until
       withCompletion:(void (^)(NSArray *posts, NSError *error))block;
- (void)addTextPostWithContent:(NSString *)content
                      username:(NSString *)username
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;
- (void)addImagePostWithContent:(NSString *)content
                       username:(NSString *)username
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;
- (void)addEventWithName:(NSString *)name
                 details:(NSString *)details
                location:(CLLocationCoordinate2D)location
               startTime:(NSDate *)startTime
                 endTime:(NSDate *)endTime
          withCompletion:(void (^)(ChanEvent *event, NSError *error))block;
@end
