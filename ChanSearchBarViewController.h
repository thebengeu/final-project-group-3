//
//  ChanSearchBarViewController.h
//  Channely
//
//  Created by Cedric on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanSearchBarViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property id<UISearchBarDelegate> delegate;

@end
