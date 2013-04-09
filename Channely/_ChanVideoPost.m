// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoPost.m instead.

#import "_ChanVideoPost.h"

const struct ChanVideoPostAttributes ChanVideoPostAttributes = {
	.endTime = @"endTime",
	.startTime = @"startTime",
	.url = @"url",
};

const struct ChanVideoPostRelationships ChanVideoPostRelationships = {
	.thumbnails = @"thumbnails",
};

const struct ChanVideoPostFetchedProperties ChanVideoPostFetchedProperties = {
};

@implementation ChanVideoPostID
@end

@implementation _ChanVideoPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"VideoPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"VideoPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"VideoPost" inManagedObjectContext:moc_];
}

- (ChanVideoPostID*)objectID {
	return (ChanVideoPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic endTime;






@dynamic startTime;






@dynamic url;






@dynamic thumbnails;

	
- (NSMutableSet*)thumbnailsSet {
	[self willAccessValueForKey:@"thumbnails"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"thumbnails"];
  
	[self didAccessValueForKey:@"thumbnails"];
	return result;
}
	






@end
