//
//  ChanCollectionViewController.h
//  Channely
//
//  Created by Cedric on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ChanTextCell.h"
#import "ChanImageCell.h"
#import "ChanVideoCell.h"
#import "ChanSlidesCell.h"
#import "ChanTwitterCell.h"
#import "ChanPost.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"
#import "ChanSlidesPost.h"
#import "ChanTwitterPost.h"
#import "ChanVideoPlayerViewController.h"
#import "ChanSlidesViewController.h"
#import "ChannelViewControllerDelegate.h"
#import "UICollectionViewWaterfallLayout.h"
#import "AwesomeMenuItem.h"
#import "AwesomeMenu.h"
#import "TimeScroller.h"

@class ChanChannel;

@interface ChanCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UICollectionViewDelegateWaterfallLayout,
AwesomeMenuDelegate, TimeScrollerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) TimeScroller *timeScroller;
@property (weak, nonatomic) id<ChannelViewControllerDelegate> delegate;
@property (strong, nonatomic) NSDate *twitterLastRefreshed;
@property (strong, nonatomic) ChanChannel *channel;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) AwesomeMenu *createPostMenu;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (CGFloat)   collectionView:(UICollectionView *)collectionView
                      layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
    heightForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshPosts;

@end