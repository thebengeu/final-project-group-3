//
//  ChanCollectionViewController.h
//  Channely
//
//  Created by Cedric on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UICollectionViewWaterfallLayout.h"
#import "AwesomeMenu.h"
#import "TimeScroller.h"

@class ChanChannel;
@protocol ChannelViewControllerDelegate;

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
