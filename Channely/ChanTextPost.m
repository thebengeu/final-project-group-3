#import "ChanTextPost.h"
#import "ChanAPIEndpoints.h"

@interface ChanTextPost ()

// Private interface goes here.

@end


@implementation ChanTextPost

- (void)deleteWithCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block
{
    [[RKObjectManager sharedManager] deleteObject:self path:PATH_DELETE_TEXT_FORMAT parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
