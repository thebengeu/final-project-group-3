// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSChunk.m instead.

#import "_ChanHLSChunk.h"

const struct ChanHLSChunkAttributes ChanHLSChunkAttributes = {
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
	
	if ([key isEqualToString:@"seqNoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seqNo"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic seqNo;



- (int16_t)seqNoValue {
	NSNumber *result = [self seqNo];
	return [result shortValue];
}

- (void)setSeqNoValue:(int16_t)value_ {
	[self setSeqNo:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSeqNoValue {
	NSNumber *result = [self primitiveSeqNo];
	return [result shortValue];
}

- (void)setPrimitiveSeqNoValue:(int16_t)value_ {
	[self setPrimitiveSeqNo:[NSNumber numberWithShort:value_]];
}





@dynamic url;






@dynamic recording;

	






@end
