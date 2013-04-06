// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanVideoPostAttributes {
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *url;
	__unsafe_unretained NSString *videoId;
} ChanVideoPostAttributes;

extern const struct ChanVideoPostRelationships {
} ChanVideoPostRelationships;

extern const struct ChanVideoPostFetchedProperties {
} ChanVideoPostFetchedProperties;







@interface ChanVideoPostID : NSManagedObjectID {}
@end

@interface _ChanVideoPost : ChanPost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanVideoPostID*)objectID;





@property (nonatomic, strong) NSDate* endTime;



//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startTime;



//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoId;



//- (BOOL)validateVideoId:(id*)value_ error:(NSError**)error_;






@end

@interface _ChanVideoPost (CoreDataGeneratedAccessors)

@end

@interface _ChanVideoPost (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;




- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




- (NSString*)primitiveVideoId;
- (void)setPrimitiveVideoId:(NSString*)value;




@end