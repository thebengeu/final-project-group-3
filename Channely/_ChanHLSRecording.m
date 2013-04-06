// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSRecording.m instead.

#import "_ChanHLSRecording.h"

const struct ChanHLSRecordingAttributes ChanHLSRecordingAttributes = {
	.channelId = @"channelId",
	.endDate = @"endDate",
	.endSeqNo = @"endSeqNo",
	.id = @"id",
	.playlistURL = @"playlistURL",
	.startDate = @"startDate",
};

const struct ChanHLSRecordingRelationships ChanHLSRecordingRelationships = {
	.chunks = @"chunks",
};

const struct ChanHLSRecordingFetchedProperties ChanHLSRecordingFetchedProperties = {
};

@implementation ChanHLSRecordingID
@end

@implementation _ChanHLSRecording

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HLSRecording" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HLSRecording";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HLSRecording" inManagedObjectContext:moc_];
}

- (ChanHLSRecordingID*)objectID {
	return (ChanHLSRecordingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"endSeqNoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endSeqNo"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic channelId;






@dynamic endDate;






@dynamic endSeqNo;



- (int32_t)endSeqNoValue {
	NSNumber *result = [self endSeqNo];
	return [result intValue];
}

- (void)setEndSeqNoValue:(int32_t)value_ {
	[self setEndSeqNo:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveEndSeqNoValue {
	NSNumber *result = [self primitiveEndSeqNo];
	return [result intValue];
}

- (void)setPrimitiveEndSeqNoValue:(int32_t)value_ {
	[self setPrimitiveEndSeqNo:[NSNumber numberWithInt:value_]];
}





@dynamic id;






@dynamic playlistURL;






@dynamic startDate;






@dynamic chunks;

	
- (NSMutableSet*)chunksSet {
	[self willAccessValueForKey:@"chunks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"chunks"];
  
	[self didAccessValueForKey:@"chunks"];
	return result;
}
	






@end
