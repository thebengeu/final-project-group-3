// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanHLSRecording.h instead.

#import <CoreData/CoreData.h>


extern const struct ChanHLSRecordingAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *videoId;
} ChanHLSRecordingAttributes;

extern const struct ChanHLSRecordingRelationships {
	__unsafe_unretained NSString *chunks;
} ChanHLSRecordingRelationships;

extern const struct ChanHLSRecordingFetchedProperties {
} ChanHLSRecordingFetchedProperties;

@class ChanHLSChunk;





@interface ChanHLSRecordingID : NSManagedObjectID {}
@end

@interface _ChanHLSRecording : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanHLSRecordingID*)objectID;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoId;



//- (BOOL)validateVideoId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *chunks;

- (NSMutableSet*)chunksSet;





@end

@interface _ChanHLSRecording (CoreDataGeneratedAccessors)

- (void)addChunks:(NSSet*)value_;
- (void)removeChunks:(NSSet*)value_;
- (void)addChunksObject:(ChanHLSChunk*)value_;
- (void)removeChunksObject:(ChanHLSChunk*)value_;

@end

@interface _ChanHLSRecording (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveVideoId;
- (void)setPrimitiveVideoId:(NSString*)value;





- (NSMutableSet*)primitiveChunks;
- (void)setPrimitiveChunks:(NSMutableSet*)value;


@end
