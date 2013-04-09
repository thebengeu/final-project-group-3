// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoThumbnailPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanImagePost.h"

extern const struct ChanVideoThumbnailPostAttributes {
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *videoId;
} ChanVideoThumbnailPostAttributes;

extern const struct ChanVideoThumbnailPostRelationships {
	__unsafe_unretained NSString *video;
} ChanVideoThumbnailPostRelationships;

extern const struct ChanVideoThumbnailPostFetchedProperties {
} ChanVideoThumbnailPostFetchedProperties;

@class ChanVideoPost;




@interface ChanVideoThumbnailPostID : NSManagedObjectID {}
@end

@interface _ChanVideoThumbnailPost : ChanImagePost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanVideoThumbnailPostID*)objectID;





@property (nonatomic, strong) NSDate* startTime;



//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* videoId;



//- (BOOL)validateVideoId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ChanVideoPost *video;

//- (BOOL)validateVideo:(id*)value_ error:(NSError**)error_;





@end

@interface _ChanVideoThumbnailPost (CoreDataGeneratedAccessors)

@end

@interface _ChanVideoThumbnailPost (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;




- (NSString*)primitiveVideoId;
- (void)setPrimitiveVideoId:(NSString*)value;





- (ChanVideoPost*)primitiveVideo;
- (void)setPrimitiveVideo:(ChanVideoPost*)value;


@end
