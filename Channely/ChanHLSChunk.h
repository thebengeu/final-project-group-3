//
//  ChanHLSChunk.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChanHLSRecording;

@interface ChanHLSChunk : NSManagedObject

@property (nonatomic, retain) NSNumber * seqNo;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) ChanHLSRecording *recording;

@end
