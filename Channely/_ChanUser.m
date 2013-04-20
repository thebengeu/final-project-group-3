// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanUser.m instead.

#import "_ChanUser.h"

const struct ChanUserAttributes ChanUserAttributes = {
	.accessToken = @"accessToken",
	.id = @"id",
	.loggedIn = @"loggedIn",
	.name = @"name",
	.password = @"password",
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
	
	if ([key isEqualToString:@"loggedInValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loggedIn"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic accessToken;






@dynamic id;






@dynamic loggedIn;



- (BOOL)loggedInValue {
	NSNumber *result = [self loggedIn];
	return [result boolValue];
}

- (void)setLoggedInValue:(BOOL)value_ {
	[self setLoggedIn:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLoggedInValue {
	NSNumber *result = [self primitiveLoggedIn];
	return [result boolValue];
}

- (void)setPrimitiveLoggedInValue:(BOOL)value_ {
	[self setPrimitiveLoggedIn:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic password;






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
