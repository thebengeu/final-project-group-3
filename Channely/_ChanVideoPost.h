// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanVideoPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanVideoPostAttributes {
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *url;
} ChanVideoPostAttributes;

extern const struct ChanVideoPostRelationships {
	__unsafe_unretained NSString *thumbnails;
} ChanVideoPostRelationships;

extern const struct ChanVideoPostFetchedProperties {
} ChanVideoPostFetchedProperties;

@class ChanVideoThumbnailPost;





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





@property (nonatomic, strong) NSSet *thumbnails;

- (NSMutableSet*)thumbnailsSet;





@end

@interface _ChanVideoPost (CoreDataGeneratedAccessors)

- (void)addThumbnails:(NSSet*)value_;
- (void)removeThumbnails:(NSSet*)value_;
- (void)addThumbnailsObject:(ChanVideoThumbnailPost*)value_;
- (void)removeThumbnailsObject:(ChanVideoThumbnailPost*)value_;

@end

@interface _ChanVideoPost (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;




- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveThumbnails;
- (void)setPrimitiveThumbnails:(NSMutableSet*)value;


@end
