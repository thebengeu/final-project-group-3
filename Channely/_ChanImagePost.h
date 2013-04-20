// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanImagePost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanImagePostAttributes {
	__unsafe_unretained NSString *height;
	__unsafe_unretained NSString *thumbUrl;
	__unsafe_unretained NSString *url;
	__unsafe_unretained NSString *width;
} ChanImagePostAttributes;

extern const struct ChanImagePostRelationships {
} ChanImagePostRelationships;

extern const struct ChanImagePostFetchedProperties {
} ChanImagePostFetchedProperties;







@interface ChanImagePostID : NSManagedObjectID {}
@end

@interface _ChanImagePost : ChanPost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanImagePostID*)objectID;





@property (nonatomic, strong) NSNumber* height;



@property int16_t heightValue;
- (int16_t)heightValue;
- (void)setHeightValue:(int16_t)value_;

//- (BOOL)validateHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thumbUrl;



//- (BOOL)validateThumbUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* width;



@property int16_t widthValue;
- (int16_t)widthValue;
- (void)setWidthValue:(int16_t)value_;

//- (BOOL)validateWidth:(id*)value_ error:(NSError**)error_;






@end

@interface _ChanImagePost (CoreDataGeneratedAccessors)

@end

@interface _ChanImagePost (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(NSNumber*)value;

- (int16_t)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(int16_t)value_;




- (NSString*)primitiveThumbUrl;
- (void)setPrimitiveThumbUrl:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




- (NSNumber*)primitiveWidth;
- (void)setPrimitiveWidth:(NSNumber*)value;

- (int16_t)primitiveWidthValue;
- (void)setPrimitiveWidthValue:(int16_t)value_;




@end
