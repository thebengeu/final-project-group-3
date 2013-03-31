// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSChunk.m instead.

#import "_ChanHLSChunk.h"

const struct ChanHLSChunkAttributes ChanHLSChunkAttributes = {
	.duration = @"duration",
	.seqNo = @"seqNo",
	.url = @"url",
};

const struct ChanHLSChunkRelationships ChanHLSChunkRelationships = {
	.recording = @"recording",
};

const struct ChanHLSChunkFetchedProperties ChanHLSChunkFetchedProperties = {
};

@implementation ChanHLSChunkID
@end

@implementation _ChanHLSChunk

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HLSChunk" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HLSChunk";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HLSChunk" inManagedObjectContext:moc_];
}

- (ChanHLSChunkID*)objectID {
	return (ChanHLSChunkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"seqNoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seqNo"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic duration;



- (double)durationValue {
	NSNumber *result = [self duration];
	return [result doubleValue];
}

- (void)setDurationValue:(double)value_ {
	[self setDuration:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result doubleValue];
}

- (void)setPrimitiveDurationValue:(double)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithDouble:value_]];
}





@dynamic seqNo;



- (int32_t)seqNoValue {
	NSNumber *result = [self seqNo];
	return [result intValue];
}

- (void)setSeqNoValue:(int32_t)value_ {
	[self setSeqNo:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSeqNoValue {
	NSNumber *result = [self primitiveSeqNo];
	return [result intValue];
}

- (void)setPrimitiveSeqNoValue:(int32_t)value_ {
	[self setPrimitiveSeqNo:[NSNumber numberWithInt:value_]];
}





@dynamic url;






@dynamic recording;

	






@end
