// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoPost.m instead.

#import "_ChanVideoPost.h"

const struct ChanVideoPostAttributes ChanVideoPostAttributes = {
	.endTime = @"endTime",
	.startTime = @"startTime",
	.url = @"url",
	.videoId = @"videoId",
};

const struct ChanVideoPostRelationships ChanVideoPostRelationships = {
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
	
	if ([key isEqualToString:@"videoIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"videoId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic endTime;






@dynamic startTime;






@dynamic url;






@dynamic videoId;



- (int64_t)videoIdValue {
	NSNumber *result = [self videoId];
	return [result longLongValue];
}

- (void)setVideoIdValue:(int64_t)value_ {
	[self setVideoId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveVideoIdValue {
	NSNumber *result = [self primitiveVideoId];
	return [result longLongValue];
}

- (void)setPrimitiveVideoIdValue:(int64_t)value_ {
	[self setPrimitiveVideoId:[NSNumber numberWithLongLong:value_]];
}










@end
