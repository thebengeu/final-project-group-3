// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanTwitterPost.m instead.

#import "_ChanTwitterPost.h"

const struct ChanTwitterPostAttributes ChanTwitterPostAttributes = {
};

const struct ChanTwitterPostRelationships ChanTwitterPostRelationships = {
};

const struct ChanTwitterPostFetchedProperties ChanTwitterPostFetchedProperties = {
};

@implementation ChanTwitterPostID
@end

@implementation _ChanTwitterPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterPost" inManagedObjectContext:moc_];
}

- (ChanTwitterPostID*)objectID {
	return (ChanTwitterPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
