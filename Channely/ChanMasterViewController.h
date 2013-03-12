//
//  ChanMasterViewController.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanDetailViewController;

#import <CoreData/CoreData.h>

@interface ChanMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ChanDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
