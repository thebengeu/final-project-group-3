// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanChannel.m instead.

#import "_ChanChannel.h"

const struct ChanChannelAttributes ChanChannelAttributes = {
	.createdAt = @"createdAt",
	.id = @"id",
	.name = @"name",
};

const struct ChanChannelRelationships ChanChannelRelationships = {
	.events = @"events",
	.owner = @"owner",
	.posts = @"posts",
};

const struct ChanChannelFetchedProperties ChanChannelFetchedProperties = {
};

@implementation ChanChannelID
@end

@implementation _ChanChannel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Channel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Channel" inManagedObjectContext:moc_];
}

- (ChanChannelID*)objectID {
	return (ChanChannelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic createdAt;






@dynamic id;






@dynamic name;






@dynamic events;

	
- (NSMutableSet*)eventsSet {
	[self willAccessValueForKey:@"events"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"events"];
  
	[self didAccessValueForKey:@"events"];
	return result;
}
	

@dynamic owner;

	

@dynamic posts;

	
- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];
  
	[self didAccessValueForKey:@"posts"];
	return result;
}
	






@end
