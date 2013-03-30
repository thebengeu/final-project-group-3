// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanTextPost.m instead.

#import "_ChanTextPost.h"

const struct ChanTextPostAttributes ChanTextPostAttributes = {
};

const struct ChanTextPostRelationships ChanTextPostRelationships = {
};

const struct ChanTextPostFetchedProperties ChanTextPostFetchedProperties = {
};

@implementation ChanTextPostID
@end

@implementation _ChanTextPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TextPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TextPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TextPost" inManagedObjectContext:moc_];
}

- (ChanTextPostID*)objectID {
	return (ChanTextPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
