// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanPost.m instead.

#import "_ChanPost.h"

const struct ChanPostAttributes ChanPostAttributes = {
	.channelId = @"channelId",
	.content = @"content",
	.createdAt = @"createdAt",
	.id = @"id",
	.username = @"username",
};

const struct ChanPostRelationships ChanPostRelationships = {
	.channel = @"channel",
	.creator = @"creator",
};

const struct ChanPostFetchedProperties ChanPostFetchedProperties = {
};

@implementation ChanPostID
@end

@implementation _ChanPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (ChanPostID*)objectID {
	return (ChanPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic channelId;






@dynamic content;






@dynamic createdAt;






@dynamic id;






@dynamic username;






@dynamic channel;

	

@dynamic creator;

	






@end
