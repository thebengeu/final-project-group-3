// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanSlidesPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanSlidesPostAttributes {
	__unsafe_unretained NSString *url;
} ChanSlidesPostAttributes;

extern const struct ChanSlidesPostRelationships {
	__unsafe_unretained NSString *slides;
} ChanSlidesPostRelationships;

extern const struct ChanSlidesPostFetchedProperties {
} ChanSlidesPostFetchedProperties;

@class ChanSlidePost;



@interface ChanSlidesPostID : NSManagedObjectID {}
@end

@interface _ChanSlidesPost : ChanPost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanSlidesPostID*)objectID;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *slides;

- (NSMutableSet*)slidesSet;





@end

@interface _ChanSlidesPost (CoreDataGeneratedAccessors)

- (void)addSlides:(NSSet*)value_;
- (void)removeSlides:(NSSet*)value_;
- (void)addSlidesObject:(ChanSlidePost*)value_;
- (void)removeSlidesObject:(ChanSlidePost*)value_;

@end

@interface _ChanSlidesPost (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveSlides;
- (void)setPrimitiveSlides:(NSMutableSet*)value;


@end
