#import "ChanUser.h"
#import "ChanAPIEndpoints.h"


@interface ChanUser ()

// Private interface goes here.

@end

static ChanUser *loggedInUser = nil;

@implementation ChanUser

+ (ChanUser *)loggedInUser
{
    return loggedInUser;
}

+ (void)logout
{
    loggedInUser = nil;
    [[RKObjectManager sharedManager].HTTPClient clearAuthorizationHeader];
}

+ (void)createUserWithUsername:(NSString *)username
                      password:(NSString *)password
                withCompletion:(void (^)(ChanUser *user, NSError *error))block
{
    ChanUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    user.name = username;
    user.password = password;
    
    [[RKObjectManager sharedManager] postObject:user path:PATH_USER parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        user.password = nil;
        if (block) block(user, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

+ (void)getAccessTokenWithUsername:(NSString *)username
                          password:(NSString *)password
                    withCompletion:(void (^)(ChanUser *user, NSError *error))block
{
    ChanUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    user.name = username;
    user.password = password;
    
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    [[RKObjectManager sharedManager] postObject:user path:PATH_GET_ACCESS_TOKEN parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        loggedInUser = user;
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", loggedInUser.accessToken]];
        
        if (block) block(user, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[RKObjectManager sharedManager].HTTPClient clearAuthorizationHeader];
        if (block) block(nil, error);
    }];
}

@end
