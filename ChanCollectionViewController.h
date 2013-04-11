//
//  ChanCollectionViewController.h
//  Channely
//
//  Created by Cedric on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanTextCell.h"
#import "ChanPost.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"

@class ChanChannel;

@interface ChanCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property ChanChannel *channel;

@end
