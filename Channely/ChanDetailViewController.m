//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"
#import "ChannelViewController.h"
#import "ChanSearchTableViewController.h"
#import "Constants.h"

@interface ChanDetailViewController ()

@property (strong) UITabBarController *homeTabController;

@property (weak) UIPopoverController *menuPopover;

@property UISearchBar *searchBar;

@end

@implementation ChanDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 200.0, 44.0)];
    _searchBar.autoresizingMask = UIViewAutoresizingNone;
    _searchBar.placeholder = kSearchBarPlaceholder;
    _searchBar.delegate = self;
    
    [self navigationItem].leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMenuSegue]) {
        _menuPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuPopover.delegate = self;
        [_searchBar endEditing:YES];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kMenuSegue]) {
        return (_menuPopover == nil);
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _menuPopover) _menuPopover = nil;
}

- (void)startChannel:(ChanChannel *)channel
{
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    ChannelViewController *channelViewController = [storyboard instantiateViewControllerWithIdentifier:kChannelVC];
    channelViewController.channel = channel;
    
    [[self navigationController]pushViewController:channelViewController animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    [self searchBarExpandAnimateWith:70];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self searchBarExpandAnimateWith:-70];
}

- (void)searchBarExpandAnimateWith:(int)width
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect newBounds = _searchBar.frame;
                         newBounds.size.width += width;
                         _searchBar.frame = newBounds;
                         [_searchBar layoutSubviews];
                     }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
    UIViewController *searchController = [storyboard instantiateViewControllerWithIdentifier:kChanSearchTableVC];
    
    [(ChanSearchTableViewController *)searchController setSearchTerm : searchTerm];
    
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    
    [[self navigationController]pushViewController:searchController animated:YES];
}

@end
