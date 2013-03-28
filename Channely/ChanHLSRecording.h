//
//  ChanHLSRecording.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanHLSChunk;

@interface ChanHLSRecording : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSSet *chunks;
@end

@interface ChanHLSRecording (CoreDataGeneratedAccessors)

- (void)addChunksObject:(ChanHLSChunk *)value;
- (void)removeChunksObject:(ChanHLSChunk *)value;
- (void)addChunks:(NSSet *)values;
- (void)removeChunks:(NSSet *)values;

@end
