// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanUser.h instead.

#import <CoreData/CoreData.h>


extern const struct ChanUserAttributes {
	__unsafe_unretained NSString *accessToken;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *loggedIn;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *password;
} ChanUserAttributes;

extern const struct ChanUserRelationships {
	__unsafe_unretained NSString *channels;
	__unsafe_unretained NSString *posts;
} ChanUserRelationships;

extern const struct ChanUserFetchedProperties {
} ChanUserFetchedProperties;

@class ChanChannel;
@class ChanPost;







@interface ChanUserID : NSManagedObjectID {}
@end

@interface _ChanUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanUserID*)objectID;





@property (nonatomic, strong) NSString* accessToken;



//- (BOOL)validateAccessToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* loggedIn;



@property BOOL loggedInValue;
- (BOOL)loggedInValue;
- (void)setLoggedInValue:(BOOL)value_;

//- (BOOL)validateLoggedIn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *channels;

- (NSMutableSet*)channelsSet;




@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;





@end

@interface _ChanUser (CoreDataGeneratedAccessors)

- (void)addChannels:(NSSet*)value_;
- (void)removeChannels:(NSSet*)value_;
- (void)addChannelsObject:(ChanChannel*)value_;
- (void)removeChannelsObject:(ChanChannel*)value_;

- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(ChanPost*)value_;
- (void)removePostsObject:(ChanPost*)value_;

@end

@interface _ChanUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccessToken;
- (void)setPrimitiveAccessToken:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveLoggedIn;
- (void)setPrimitiveLoggedIn:(NSNumber*)value;

- (BOOL)primitiveLoggedInValue;
- (void)setPrimitiveLoggedInValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;





- (NSMutableSet*)primitiveChannels;
- (void)setPrimitiveChannels:(NSMutableSet*)value;



- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;


@end
