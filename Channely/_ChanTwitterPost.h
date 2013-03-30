// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanTwitterPost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanTwitterPostAttributes {
	__unsafe_unretained NSString *jsonData;
	__unsafe_unretained NSString *url;
} ChanTwitterPostAttributes;

extern const struct ChanTwitterPostRelationships {
} ChanTwitterPostRelationships;

extern const struct ChanTwitterPostFetchedProperties {
} ChanTwitterPostFetchedProperties;


@class NSObject;


@interface ChanTwitterPostID : NSManagedObjectID {}
@end

@interface _ChanTwitterPost : ChanPost {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanTwitterPostID*)objectID;





@property (nonatomic, strong) id jsonData;



//- (BOOL)validateJsonData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _ChanTwitterPost (CoreDataGeneratedAccessors)

@end

@interface _ChanTwitterPost (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveJsonData;
- (void)setPrimitiveJsonData:(id)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
