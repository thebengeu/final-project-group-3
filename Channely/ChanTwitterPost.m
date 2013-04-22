#import "ChanTwitterPost.h"
#import "ChanAPIEndpoints.h"


@interface ChanTwitterPost ()

// Private interface goes here.

@end


@implementation ChanTwitterPost

- (ChanPostType)typeConstant
{
    return kTwitterPost;
}

- (NSString *)url
{
    return [NSString stringWithFormat:@"https://twitter.com/%@/status/%@", self.username, self.id];
}

+ (void)getTweetsWithHashTag:(NSString *)hashtag WithCompletion:(void (^)(NSArray *tweets, NSError *error))block
{
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKEntityMapping *twitterPostMapping = [RKEntityMapping mappingForEntityForName:@"TwitterPost" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    [twitterPostMapping addAttributeMappingsFromDictionary:@{
     @"created_at":         @"createdAt",
     @"id_str":             @"id",
     @"user.screen_name":   @"username",
     @"text":               @"content"}];
    twitterPostMapping.identificationAttributes = @[ @"id" ];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:twitterPostMapping pathPattern:nil keyPath:@"statuses" statusCodes:statusCodes];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@", [hashtag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", TWITTER_BEARER_TOKEN] forHTTPHeaderField:@"Authorization"];
    
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    operation.managedObjectContext = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
    operation.managedObjectCache = [[RKManagedObjectStore defaultStore] managedObjectCache];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if (block) block([result array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

@end
