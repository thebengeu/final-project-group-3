// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanImagePost.h instead.

#import <CoreData/CoreData.h>
#import "ChanPost.h"

extern const struct ChanImagePostAttributes {
	__unsafe_unretained NSString *url;
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





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _ChanImagePost (CoreDataGeneratedAccessors)

@end

@interface _ChanImagePost (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
