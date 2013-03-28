//
//  ChanTimeline.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanEvent, ChanPost, ChanUser;

@interface ChanTimeline : NSManagedObject

@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) ChanUser *owner;
@property (nonatomic, retain) NSSet *posts;
@end

@interface ChanTimeline (CoreDataGeneratedAccessors)

- (void)addEventsObject:(ChanEvent *)value;
- (void)removeEventsObject:(ChanEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addPostsObject:(ChanPost *)value;
- (void)removePostsObject:(ChanPost *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
