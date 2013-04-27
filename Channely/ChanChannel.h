#import "_ChanChannel.h"
#import <MapKit/MapKit.h>

@class ChanTextPost;
@class ChanImagePost;

/**
 `ChanChannel` wraps API and persistence operations for Channely channels.
 */
@interface ChanChannel : _ChanChannel {}

/**
 Gets all channels in Channely.

 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an NSArray of all channels and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block;

/**
 Creates and returns new channel with given name and hashtag.
 
 @param name The name of the created channel.
 @param hashTag The hashtag of the created channel.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the created channel and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)addChannelWithName:(NSString *)name hashTag:(NSString *)hashTag withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;

/**
 Searches for channels with names containing given substring.
 
 @param name The substring to match against channel names.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an NSArray of the searched for channels and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)search:(NSString *)name withCompletion:(void (^)(NSArray *channels, NSError *error))block;

/**
 Updates channel with given name and hashtag.
 
 @param name The name to update the channel with.
 @param hashTag The hashtag to update the channel with.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the updated channel and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)updateChannelWithName:(NSString *)name hashTag:(NSString *)hashTag withCompletion:(void (^)(ChanChannel *channel, NSError *error))block;

/**
 Deletes channel.
 
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the deleted channel and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)deleteWithCompletion:(void (^)(ChanChannel *channel, NSError *error))block;

/**
 Gets posts for channel between given since and until parameters. If both parameters are nil, all posts will be retrieved.
 
 @param since Posts since this date/time will be retrieved. If nil, posts since the beginning will be retrieved.
 @param until Posts until this date/time will be retrieved. If nil, posts until now will be retrieved.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an NSArray of the posts and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)getPostsSince:(NSDate *)since
                until:(NSDate *)until
       withCompletion:(void (^)(NSArray *posts, NSError *error))block;

/**
 Adds new text post to channel.
 
 @param content The content for the text post.
 @param username The username to attribute the image post to. Will be ignored if user is logged in.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the added text post and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)addTextPostWithContent:(NSString *)content
                      username:(NSString *)username
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block;

/**
 Adds new image post to channel.
 
 @param content The caption content for the image post.
 @param username The username to attribute the image post to. Will be ignored if user is logged in.
 @param image The image to be added.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the added image post and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)addImagePostWithContent:(NSString *)content
                       username:(NSString *)username
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block;

/**
 Adds new event to channel.
 
 @param name The name of the event.
 @param details The details of the event.
 @param location The location of the event.
 @param startTime The starting time of the event.
 @param endTime The ending time of the event.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the added event and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)addEventWithName:(NSString *)name
                 details:(NSString *)details
                location:(CLLocationCoordinate2D)location
               startTime:(NSDate *)startTime
                 endTime:(NSDate *)endTime
          withCompletion:(void (^)(ChanEvent *event, NSError *error))block;

/**
 Gets tweets using the channel's assigned hashtag. Does nothing if length of hashtag is below 2 characters.

 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: an array of the tweets and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)getTweetsWithCompletion:(void (^)(NSArray *tweets, NSError *error))block;

@end
