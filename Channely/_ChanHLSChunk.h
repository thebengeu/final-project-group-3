// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSChunk.h instead.

#import <CoreData/CoreData.h>


extern const struct ChanHLSChunkAttributes {
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *seqNo;
	__unsafe_unretained NSString *url;
} ChanHLSChunkAttributes;

extern const struct ChanHLSChunkRelationships {
	__unsafe_unretained NSString *recording;
} ChanHLSChunkRelationships;

extern const struct ChanHLSChunkFetchedProperties {
} ChanHLSChunkFetchedProperties;

@class ChanHLSRecording;






@interface ChanHLSChunkID : NSManagedObjectID {}
@end

@interface _ChanHLSChunk : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanHLSChunkID*)objectID;





@property (nonatomic, strong) NSNumber* duration;



@property double durationValue;
- (double)durationValue;
- (void)setDurationValue:(double)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* seqNo;



@property int32_t seqNoValue;
- (int32_t)seqNoValue;
- (void)setSeqNoValue:(int32_t)value_;

//- (BOOL)validateSeqNo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ChanHLSRecording *recording;

//- (BOOL)validateRecording:(id*)value_ error:(NSError**)error_;





@end

@interface _ChanHLSChunk (CoreDataGeneratedAccessors)

@end

@interface _ChanHLSChunk (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (double)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(double)value_;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveSeqNo;
- (void)setPrimitiveSeqNo:(NSNumber*)value;

- (int32_t)primitiveSeqNoValue;
- (void)setPrimitiveSeqNoValue:(int32_t)value_;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (ChanHLSRecording*)primitiveRecording;
- (void)setPrimitiveRecording:(ChanHLSRecording*)value;


@end
