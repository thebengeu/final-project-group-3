#import "ChanChannel.h"
#import "ChanImagePost.h"
#import "ChanTextPost.h"
#import "ChanAPIEndpoints.h"
#import "ChanEvent.h"

@interface ChanChannel ()

// Private interface goes here.

@end


@implementation ChanChannel

+ (void)getAllChannelsWithCompletion:(void (^)(NSArray *channels, NSError *error))block
{
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_CHANNEL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

+ (void)addChannelWithName:(NSString *)name withCompletion:(void (^)(ChanChannel *channel, NSError *error))block
{
    ChanChannel *channel = [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    channel.name = name;

    [[RKObjectManager sharedManager] postObject:channel path:PATH_CHANNEL parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(channel, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)getPostsSince:(NSDate *)since
                until:(NSDate *)until
       withCompletion:(void (^)(NSArray *posts, NSError *error))block {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (since) {
        [params setObject:[NSNumber numberWithDouble:[since timeIntervalSince1970] * 1000] forKey:@"since"];
    }
    if (until) {
        [params setObject:[NSNumber numberWithDouble:[until timeIntervalSince1970] * 1000] forKey:@"until"];
    }
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:PATH_POSTS_UNIFIED_GET_FORMAT, self.id] parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)addTextPostWithContent:(NSString *)content
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block
{
    ChanTextPost *textPost = [NSEntityDescription insertNewObjectForEntityForName:@"TextPost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    textPost.content = content;
    [self addPostsObject:textPost];
    
    [[RKObjectManager sharedManager] postObject:textPost path:[NSString stringWithFormat:PATH_POST_TEXT_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(textPost, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

- (void)addImagePostWithContent:(NSString *)content
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block
{
    ChanImagePost *imagePost = [NSEntityDescription insertNewObjectForEntityForName:@"ImagePost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    imagePost.content = content;
    [self addPostsObject:imagePost];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:imagePost method:RKRequestMethodPOST path:[NSString stringWithFormat:PATH_POST_IMAGE_FORMAT, self.id] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                    name:@"image"
                                fileName:@"image.png"
                                mimeType:@"image/png"];
    }];
    
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(imagePost, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (void)addEventWithName:(NSString *)name
                 details:(NSString *)details
                location:(CLLocationCoordinate2D)location
               startTime:(NSDate *)startTime
                 endTime:(NSDate *)endTime
          withCompletion:(void (^)(ChanEvent *event, NSError *error))block
{
    ChanEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    event.name = name;
    event.details = details;
    event.latitudeValue = location.latitude;
    event.longitudeValue = location.longitude;
    event.startTime = startTime;
    event.endTime = endTime;
    [self addEventsObject:event];
    
    [[RKObjectManager sharedManager] postObject:event path:PATH_EVENTS_POST parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(event, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
