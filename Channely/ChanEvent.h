//
//  ChanEvent.h
//  Channely
//
//  Created by Beng on 15/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanTimeline;

@interface ChanEvent : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) ChanTimeline *timeline;

@end
