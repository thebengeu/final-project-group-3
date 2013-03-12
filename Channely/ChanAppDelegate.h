//
//  ChanAppDelegate.h
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
