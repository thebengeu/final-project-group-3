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

NSString *const cMenuSegueIdentifier = @"MenuSegue";
NSString *const cSearchSegueIdentifier = @"SearchSegue";

@interface ChanDetailViewController ()

@property (strong) UITabBarController *homeTabController;

@property (weak) UIPopoverController *menuPopover;
@property UIPopoverController *searchPopover;

@end

@implementation ChanDetailViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:cMenuSegueIdentifier]) {
        [_searchPopover dismissPopoverAnimated:YES];
        _searchPopover = nil;
        
        _menuPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuPopover.delegate = self;
    } else if ([segue.identifier isEqualToString:cSearchSegueIdentifier]) {
        [_menuPopover dismissPopoverAnimated:YES];
        _menuPopover = nil;
        
        _searchPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _searchPopover.delegate = self;
        ChanSearchBarViewController *searchViewController = (ChanSearchBarViewController *) [_searchPopover contentViewController];
        [searchViewController searchBar].delegate = self;
    }
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:cMenuSegueIdentifier]) {
        return (_menuPopover == nil);
    } else if ([identifier isEqualToString:cSearchSegueIdentifier]) {
        return (_searchPopover == nil);
    }
    return YES;
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _searchPopover)
        _searchPopover = nil;
    if (popoverController == _menuPopover)
        _menuPopover = nil;
}

- (void)startChannel:(ChanChannel*)channel{
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChannelViewController *channelViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    channelViewController.channel = channel;
    
    [[self navigationController]pushViewController:channelViewController animated:YES];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchTerm = [searchBar text];
    [_searchPopover dismissPopoverAnimated:NO];
    _searchPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *searchController = [storyboard instantiateViewControllerWithIdentifier:@"ChanSearchTableViewController"];
    
    [(ChanSearchTableViewController*)searchController setSearchTerm: searchTerm];
    [[self navigationController]pushViewController:searchController animated:YES];
}

@end
