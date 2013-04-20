// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanImagePost.m instead.

#import "_ChanImagePost.h"

const struct ChanImagePostAttributes ChanImagePostAttributes = {
	.height = @"height",
	.thumbUrl = @"thumbUrl",
	.url = @"url",
	.width = @"width",
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
	
	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"widthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"width"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic height;



- (int16_t)heightValue {
	NSNumber *result = [self height];
	return [result shortValue];
}

- (void)setHeightValue:(int16_t)value_ {
	[self setHeight:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result shortValue];
}

- (void)setPrimitiveHeightValue:(int16_t)value_ {
	[self setPrimitiveHeight:[NSNumber numberWithShort:value_]];
}





@dynamic thumbUrl;






@dynamic url;






@dynamic width;



- (int16_t)widthValue {
	NSNumber *result = [self width];
	return [result shortValue];
}

- (void)setWidthValue:(int16_t)value_ {
	[self setWidth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWidthValue {
	NSNumber *result = [self primitiveWidth];
	return [result shortValue];
}

- (void)setPrimitiveWidthValue:(int16_t)value_ {
	[self setPrimitiveWidth:[NSNumber numberWithShort:value_]];
}










@end
