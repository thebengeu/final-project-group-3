#import "ChanChannel.h"
#import "ChanImagePost.h"
#import "ChanTextPost.h"

@interface ChanChannel ()

// Private interface goes here.

@end


@implementation ChanChannel

- (void)getPostsWithCompletion:(void (^)(NSArray *posts, NSError *error))block {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:@"/channels/%@/posts", self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block([mappingResult array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addTextPostWithContent:(NSString *)content
                withCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block
{
    ChanTextPost *textPost = [NSEntityDescription insertNewObjectForEntityForName:@"TextPost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    textPost.content = content;
    [self addPostsObject:textPost];
    
    [[RKObjectManager sharedManager] postObject:textPost path:[NSString stringWithFormat:@"/channels/%@/posts/text", self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(textPost, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addImagePostWithContent:(NSString *)content
                          image:(UIImage *)image
                 withCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block
{
    ChanImagePost *imagePost = [NSEntityDescription insertNewObjectForEntityForName:@"ImagePost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    imagePost.content = content;
    [self addPostsObject:imagePost];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:imagePost method:RKRequestMethodPOST path:[NSString stringWithFormat:@"/channels/%@/posts/image", self.id] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                    name:@"image"
                                fileName:@"image.png"
                                mimeType:@"image/png"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(imagePost, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

@end
