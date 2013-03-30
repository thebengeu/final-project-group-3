// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSRecording.m instead.

#import "_ChanHLSRecording.h"

const struct ChanHLSRecordingAttributes ChanHLSRecordingAttributes = {
	.endDate = @"endDate",
	.startDate = @"startDate",
	.videoId = @"videoId",
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
	

	return keyPaths;
}




@dynamic endDate;






@dynamic startDate;






@dynamic videoId;






@dynamic chunks;

	
- (NSMutableSet*)chunksSet {
	[self willAccessValueForKey:@"chunks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"chunks"];
  
	[self didAccessValueForKey:@"chunks"];
	return result;
}
	






@end
