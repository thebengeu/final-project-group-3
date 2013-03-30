// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanUser.m instead.

#import "_ChanUser.h"

const struct ChanUserAttributes ChanUserAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct ChanUserRelationships ChanUserRelationships = {
	.channels = @"channels",
	.posts = @"posts",
};

const struct ChanUserFetchedProperties ChanUserFetchedProperties = {
};

@implementation ChanUserID
@end

@implementation _ChanUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (ChanUserID*)objectID {
	return (ChanUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic channels;

	
- (NSMutableSet*)channelsSet {
	[self willAccessValueForKey:@"channels"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"channels"];
  
	[self didAccessValueForKey:@"channels"];
	return result;
}
	

@dynamic posts;

	
- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];
  
	[self didAccessValueForKey:@"posts"];
	return result;
}
	






@end
