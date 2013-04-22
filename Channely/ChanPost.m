#import "ChanPost.h"


@interface ChanPost ()

// Private interface goes here.

@end


@implementation ChanPost

- (ChanPostType)typeConstant
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
