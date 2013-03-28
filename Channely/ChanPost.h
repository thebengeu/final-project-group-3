//
//  ChanPost.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanTimeline, ChanUser;

@interface ChanPost : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) ChanUser *creator;
@property (nonatomic, retain) ChanTimeline *timeline;

@end
