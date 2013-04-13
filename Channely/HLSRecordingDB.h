//
//  HLSRecordingDB.h
//  Channely
//
//  Created by Camillus Gerard Cai on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSStreamAdvertisement.h"

@interface HLSRecordingDB : NSObject
- (void) addRecording:(HLSStreamAdvertisement *)ad;
- (void) removeRecordingsForHost:(NSString *)host;
- (NSArray *) advertisementsForRecordingId:(NSString *)rId;
- (void) clear;

@end
