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
#import "ChanPost.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"
#import "ChanSlidesPost.h"
#import "ChanVideoPlayerViewController.h"
#import "ChanSlidesViewController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "AwesomeMenuItem.h"
#import "AwesomeMenu.h"

@class ChanChannel;

@interface ChanCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UICollectionViewDelegateWaterfallLayout,
    AwesomeMenuDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) ChanChannel *channel;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) AwesomeMenu *createPostMenu;

-(CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
