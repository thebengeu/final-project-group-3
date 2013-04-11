// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanSlidePost.h instead.

#import <CoreData/CoreData.h>
#import "ChanImagePost.h"

extern const struct ChanSlidePostAttributes {
	__unsafe_unretained NSString *slidesPostId;
} ChanSlidePostAttributes;

extern const struct ChanSlidePostRelationships {
	__unsafe_unretained NSString *slidesPost;
} ChanSlidePostRelationships;

extern const struct ChanSlidePostFetchedProperties {
} ChanSlidePostFetchedProperties;

@class ChanSlidesPost;



@interface ChanSlidePostID : NSManagedObjectID {}
@end

@interface _ChanSlidePost : ChanImagePost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanSlidePostID*)objectID;





@property (nonatomic, strong) NSString* slidesPostId;



//- (BOOL)validateSlidesPostId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ChanSlidesPost *slidesPost;

//- (BOOL)validateSlidesPost:(id*)value_ error:(NSError**)error_;





@end

@interface _ChanSlidePost (CoreDataGeneratedAccessors)

@end

@interface _ChanSlidePost (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSlidesPostId;
- (void)setPrimitiveSlidesPostId:(NSString*)value;





- (ChanSlidesPost*)primitiveSlidesPost;
- (void)setPrimitiveSlidesPost:(ChanSlidesPost*)value;


@end
