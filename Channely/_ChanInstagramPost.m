// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanInstagramPost.m instead.

#import "_ChanInstagramPost.h"

const struct ChanInstagramPostAttributes ChanInstagramPostAttributes = {
	.jsonData = @"jsonData",
	.url = @"url",
};

const struct ChanInstagramPostRelationships ChanInstagramPostRelationships = {
};

const struct ChanInstagramPostFetchedProperties ChanInstagramPostFetchedProperties = {
};

@implementation ChanInstagramPostID
@end

@implementation _ChanInstagramPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"InstagramPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"InstagramPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"InstagramPost" inManagedObjectContext:moc_];
}

- (ChanInstagramPostID*)objectID {
	return (ChanInstagramPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic jsonData;






@dynamic url;











@end
