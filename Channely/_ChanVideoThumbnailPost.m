// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoThumbnailPost.m instead.

#import "_ChanVideoThumbnailPost.h"

const struct ChanVideoThumbnailPostAttributes ChanVideoThumbnailPostAttributes = {
	.videoId = @"videoId",
};

const struct ChanVideoThumbnailPostRelationships ChanVideoThumbnailPostRelationships = {
};

const struct ChanVideoThumbnailPostFetchedProperties ChanVideoThumbnailPostFetchedProperties = {
};

@implementation ChanVideoThumbnailPostID
@end

@implementation _ChanVideoThumbnailPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"VideoThumbnailPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"VideoThumbnailPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"VideoThumbnailPost" inManagedObjectContext:moc_];
}

- (ChanVideoThumbnailPostID*)objectID {
	return (ChanVideoThumbnailPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic videoId;











@end
