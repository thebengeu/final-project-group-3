//
//  ChanInstagramPost.h
//  Channely
//
//  Created by Beng on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChanPost.h"


@interface ChanInstagramPost : ChanPost

@property (nonatomic, retain) id jsonData;
@property (nonatomic, retain) NSString * url;

@end
