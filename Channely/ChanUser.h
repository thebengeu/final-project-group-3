#import "_ChanUser.h"

@interface ChanUser : _ChanUser {}

+ (ChanUser *)loggedInUser;
+ (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                withCompletion:(void (^)(ChanUser *user, NSError *error))block;
+ (void)getAccessTokenWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void (^)(ChanUser *user, NSError *error))block;

@end
