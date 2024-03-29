#import "ChanTextPost.h"
#import "ChanAPIEndpoints.h"

@implementation ChanTextPost

- (ChanPostType)typeConstant
{
    return kTextPost;
}

- (void)deleteWithCompletion:(void (^)(ChanTextPost *textPost, NSError *error))block
{
    [[RKObjectManager sharedManager] deleteObject:self path:[NSString stringWithFormat:PATH_DELETE_TEXT_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
