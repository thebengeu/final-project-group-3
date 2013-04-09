//
//  ChanPeerSelection.h
//  Channely
//
//  Created by k on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/*
 *  selection  = [[ChanPeerSelection alloc]init];
 *  selection.delegate = self;
 *  [selection selectBestPeerForRecordingId:@"516403613559ec8b26000210"];
 *  delegate to implement: -(void)selectedBestPeerForRecordingId:(NSURL *)url;
 *
 *
 */


#import <UIKit/UIKit.h>

@protocol PeerSelectionDelegate

- (void) selectedBestPeerForRecordingId: (NSURL*)url;

@end


@interface ChanPeerSelection : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property id<PeerSelectionDelegate> delegate;

- (void) selectBestPeerForRecordingId:(NSString *) rId;

@end
