// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanSlidePost.m instead.

#import "_ChanSlidePost.h"

const struct ChanSlidePostAttributes ChanSlidePostAttributes = {
	.slidesPostId = @"slidesPostId",
};

const struct ChanSlidePostRelationships ChanSlidePostRelationships = {
	.slidesPost = @"slidesPost",
};

const struct ChanSlidePostFetchedProperties ChanSlidePostFetchedProperties = {
};

@implementation ChanSlidePostID
@end

@implementation _ChanSlidePost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SlidePost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SlidePost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SlidePost" inManagedObjectContext:moc_];
}

- (ChanSlidePostID*)objectID {
	return (ChanSlidePostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic slidesPostId;






@dynamic slidesPost;

	






@end
