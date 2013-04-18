//
//  HLSPlaylistDownloadOperationDelegate.h
//  Channely
//
//  Created by Camillus Gerard Cai on 18/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLSPlaylistDownloadOperation;

@protocol HLSPlaylistDownloadOperationDelegate <NSObject>
- (void) playlistDownloadOperationDidStart:(HLSPlaylistDownloadOperation *)operation;
- (void) playlistDownloadOperationDidFinish:(HLSPlaylistDownloadOperation *)operation;

@end
