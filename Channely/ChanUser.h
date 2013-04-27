#import "_ChanUser.h"

/**
 `ChanUser` wraps API and persistence operations for Channely users.
 */
@interface ChanUser : _ChanUser {}

/**
 Get currently logged in user.
 
 @return The currently logged in user.
 */
+ (ChanUser *)loggedInUser;

/**
 Login with given user.
 
 @param user The user to login with. All subsequent API requests will carry the given user's authentication information.
 */
+ (void)login:(ChanUser *)user;

/**
 Logout the currently logged in user. Any subsequent API requests will no longer carry any authentication information.
 */
+ (void)logout;

/**
 Creates and returns new user with given username and password.
 
 @param username The username of the created user.
 @param password The password of the created user.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the created user and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                withCompletion:(void (^)(ChanUser *user, NSError *error))block;

/**
 Gets access token for user with given username and password, storing retrieved access token in user.accessToken.
 
 @param username The username of the created user.
 @param password The password of the created user.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the updated user and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)getAccessTokenWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void (^)(ChanUser *user, NSError *error))block;

/**
 Gets channels that the user owns.

 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the channels that the user owns and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)getOwnedChannels:(void (^)(NSArray *channels, NSError *error))block;

/**
 Updates user with given name and password.
 
 @param name The name to update the user with.
 @param password The password to update the user with.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the updated user and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)updateUser:(NSString *)name password:(NSString *)password withCompletion:(void (^)(ChanUser *user, NSError *error))block;

@end
