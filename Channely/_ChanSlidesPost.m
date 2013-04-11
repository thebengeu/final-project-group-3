// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanSlidesPost.m instead.

#import "_ChanSlidesPost.h"

const struct ChanSlidesPostAttributes ChanSlidesPostAttributes = {
	.url = @"url",
};

const struct ChanSlidesPostRelationships ChanSlidesPostRelationships = {
	.slides = @"slides",
};

const struct ChanSlidesPostFetchedProperties ChanSlidesPostFetchedProperties = {
};

@implementation ChanSlidesPostID
@end

@implementation _ChanSlidesPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SlidesPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SlidesPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SlidesPost" inManagedObjectContext:moc_];
}

- (ChanSlidesPostID*)objectID {
	return (ChanSlidesPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic url;






@dynamic slides;

	
- (NSMutableSet*)slidesSet {
	[self willAccessValueForKey:@"slides"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"slides"];
  
	[self didAccessValueForKey:@"slides"];
	return result;
}
	






@end
