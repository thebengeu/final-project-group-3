//
//  HLSDownloader.h
//  StreamSyncTest
//
//  Created by Camillus Gerard Cai on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSChunkDownloadOperation.h"
#import "HLSChunkDownloadMetaData.h"
#import "HLSEventPlaylistHelper.h"

@interface HLSStreamDownloader : NSObject
@property (atomic, readonly) BOOL isConsumed;

- (id) initWithPlaylist:(NSURL *)playlist;
- (void) downloadToDirectory:(NSString *)directory;

@end
