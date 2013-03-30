// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanInstagramPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanInstagramPostAttributes {
	__unsafe_unretained NSString *jsonData;
	__unsafe_unretained NSString *url;
} ChanInstagramPostAttributes;

extern const struct ChanInstagramPostRelationships {
} ChanInstagramPostRelationships;

extern const struct ChanInstagramPostFetchedProperties {
} ChanInstagramPostFetchedProperties;


@class NSObject;


@interface ChanInstagramPostID : NSManagedObjectID {}
@end

@interface _ChanInstagramPost : ChanPost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanInstagramPostID*)objectID;





@property (nonatomic, strong) id jsonData;



//- (BOOL)validateJsonData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _ChanInstagramPost (CoreDataGeneratedAccessors)

@end

@interface _ChanInstagramPost (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveJsonData;
- (void)setPrimitiveJsonData:(id)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
