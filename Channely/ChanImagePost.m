#import "ChanImagePost.h"
#import "ChanAPIEndpoints.h"
#import "Constants.h"

@implementation ChanImagePost

- (ChanPostType)typeConstant
{
    return kImagePost;
}

- (CGFloat)thumbWidth
{
    return kImageCellThumbnailWidth;
}

- (CGFloat)thumbHeight
{
    return kImageCellThumbnailWidth / self.widthValue * self.heightValue;
}

- (void)deleteWithCompletion:(void (^)(ChanImagePost *imagePost, NSError *error))block
{
    [[RKObjectManager sharedManager] deleteObject:self path:[NSString stringWithFormat:PATH_DELETE_IMAGE_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (block) block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
}

@end
