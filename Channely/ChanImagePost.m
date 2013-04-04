#import "ChanImagePost.h"
#import "ChanAPIEndpoints.h"


@interface ChanImagePost ()

// Private interface goes here.

@end


@implementation ChanImagePost

- (void)deleteWithCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block
{
    [[RKObjectManager sharedManager] deleteObject:self path:PATH_DELETE_IMAGE_FORMAT parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
