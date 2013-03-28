//
//  ChanUser.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanChannel, ChanPost;

@interface ChanUser : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) NSSet *channels;
@end

@interface ChanUser (CoreDataGeneratedAccessors)

- (void)addPostsObject:(ChanPost *)value;
- (void)removePostsObject:(ChanPost *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addChannelsObject:(ChanChannel *)value;
- (void)removeChannelsObject:(ChanChannel *)value;
- (void)addChannels:(NSSet *)values;
- (void)removeChannels:(NSSet *)values;

@end
