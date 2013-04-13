#import "_ChanUser.h"

@interface ChanUser : _ChanUser {}

+ (ChanUser *)loggedInUser;
+ (void)logout;
+ (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                withCompletion:(void (^)(ChanUser *user, NSError *error))block;
+ (void)getAccessTokenWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void (^)(ChanUser *user, NSError *error))block;
- (void)getOwnedChannels:(void (^)(NSArray *channels, NSError *error))block;
- (void)updateUser:(NSString *)name password:(NSString *)password withCompletion:(void (^)(ChanUser *user, NSError *error))block;

@end
