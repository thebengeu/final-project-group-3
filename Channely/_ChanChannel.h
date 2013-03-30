// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanChannel.h instead.

#import <CoreData/CoreData.h>


extern const struct ChanChannelAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} ChanChannelAttributes;

extern const struct ChanChannelRelationships {
	__unsafe_unretained NSString *events;
	__unsafe_unretained NSString *owner;
	__unsafe_unretained NSString *posts;
} ChanChannelRelationships;

extern const struct ChanChannelFetchedProperties {
} ChanChannelFetchedProperties;

@class ChanEvent;
@class ChanUser;
@class ChanPost;





@interface ChanChannelID : NSManagedObjectID {}
@end

@interface _ChanChannel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanChannelID*)objectID;





@property (nonatomic, strong) NSString* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *events;

- (NSMutableSet*)eventsSet;




@property (nonatomic, strong) ChanUser *owner;

//- (BOOL)validateOwner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;





@end

@interface _ChanChannel (CoreDataGeneratedAccessors)

- (void)addEvents:(NSSet*)value_;
- (void)removeEvents:(NSSet*)value_;
- (void)addEventsObject:(ChanEvent*)value_;
- (void)removeEventsObject:(ChanEvent*)value_;

- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(ChanPost*)value_;
- (void)removePostsObject:(ChanPost*)value_;

@end

@interface _ChanChannel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveEvents;
- (void)setPrimitiveEvents:(NSMutableSet*)value;



- (ChanUser*)primitiveOwner;
- (void)setPrimitiveOwner:(ChanUser*)value;



- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;


@end
