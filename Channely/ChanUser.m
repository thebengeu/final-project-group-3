#import "ChanUser.h"
#import "ChanAPIEndpoints.h"
#import "ChanChannel.h"


@interface ChanUser ()

// Private interface goes here.

@end

static ChanUser *loggedInUser = nil;

@implementation ChanUser

+ (ChanUser *)loggedInUser
{
    return loggedInUser;
}

+ (void)login:(ChanUser *)user
{
    user.loggedInValue = YES;
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", user.accessToken]];
    loggedInUser = user;
}

+ (void)logout
{
    loggedInUser.loggedInValue = NO;
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
        // Logout any other possibly logged in users
        NSManagedObjectContext *managedObjectContext = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"loggedIn == YES"];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (array == nil) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } else if (array.count) {
            for (ChanUser *chanUser in array) {
                chanUser.loggedInValue = NO;
            }
        }
        
        [ChanUser login:user];
        
        if (block) block(user, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [[RKObjectManager sharedManager].HTTPClient clearAuthorizationHeader];
        if (block) block(nil, error);
    }];
}

- (void)updateUser:(NSString *)name password:(NSString *)password withCompletion:(void (^)(ChanUser *user, NSError *error))block
{
    self.name = name;
    self.password = password;
    
    [[RKObjectManager sharedManager] putObject:self path:[NSString stringWithFormat:PATH_USER_UPDATE_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.password = nil;
        if (block) block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)getOwnedChannels:(void (^)(NSArray *channels, NSError *error))block
{
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:PATH_OWNED_CHANNELS_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
