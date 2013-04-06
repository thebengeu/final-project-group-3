// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ChanPost.h instead.

#import <CoreData/CoreData.h>


extern const struct ChanPostAttributes {
	__unsafe_unretained NSString *channelId;
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *username;
} ChanPostAttributes;

extern const struct ChanPostRelationships {
	__unsafe_unretained NSString *channel;
	__unsafe_unretained NSString *creator;
} ChanPostRelationships;

extern const struct ChanPostFetchedProperties {
} ChanPostFetchedProperties;

@class ChanChannel;
@class ChanUser;







@interface ChanPostID : NSManagedObjectID {}
@end

@interface _ChanPost : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ChanPostID*)objectID;





@property (nonatomic, strong) NSString* channelId;



//- (BOOL)validateChannelId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ChanChannel *channel;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) ChanUser *creator;

//- (BOOL)validateCreator:(id*)value_ error:(NSError**)error_;





@end

@interface _ChanPost (CoreDataGeneratedAccessors)

@end

@interface _ChanPost (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveChannelId;
- (void)setPrimitiveChannelId:(NSString*)value;




- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;





- (ChanChannel*)primitiveChannel;
- (void)setPrimitiveChannel:(ChanChannel*)value;



- (ChanUser*)primitiveCreator;
- (void)setPrimitiveCreator:(ChanUser*)value;


@end
