// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanImagePost.m instead.

#import "_ChanImagePost.h"

const struct ChanImagePostAttributes ChanImagePostAttributes = {
	.url = @"url",
};

const struct ChanImagePostRelationships ChanImagePostRelationships = {
};

const struct ChanImagePostFetchedProperties ChanImagePostFetchedProperties = {
};

@implementation ChanImagePostID
@end

@implementation _ChanImagePost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ImagePost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ImagePost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ImagePost" inManagedObjectContext:moc_];
}

- (ChanImagePostID*)objectID {
	return (ChanImagePostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic url;











@end
