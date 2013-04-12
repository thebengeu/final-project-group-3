//
//  ChanDetailViewController.m
//  Channely
//
//  Created by Beng on 13/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanDetailViewController.h"
#import "ChannelViewController.h"
#import "ChanMenuViewController.h"
#import "ChanSearchBarViewController.h"
#import "ChanEvent.h"
#import "ChanSearchTableViewController.h"

NSString *const cTabBarSegueIdentifier = @"embeddedTabBarSegue";
NSString *const cMenuSegueIdentifier = @"popoverMenuSegue";
CGFloat const cMenuPopoverWidth = 341.;
CGFloat const cMaxMenuPopoverHeight = 704.;

@interface ChanDetailViewController ()

@property (strong) UITabBarController *_homeTabController;
@property (weak) UIPopoverController *_menuSegue;

@property UIPopoverController *searchPopover;

@property UIPopoverController *channelPopover;

- (CGSize) calcMenuPopoverSize;

@end

@implementation ChanDetailViewController
@synthesize _homeTabController;
@synthesize _menuSegue;


- (void) viewDidLoad {
    [super viewDidLoad];
    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:cTabBarSegueIdentifier]) {
        self._homeTabController = (UITabBarController *)segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:cMenuSegueIdentifier]) {
        [_searchPopover dismissPopoverAnimated:YES];
        _searchPopover = nil;
        [_channelPopover dismissPopoverAnimated:YES];
        _channelPopover = nil;
        
        _menuSegue = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuSegue.popoverContentSize = [self calcMenuPopoverSize];
        _menuSegue.delegate = self;
        ChanMenuViewController *content = (ChanMenuViewController*)_menuSegue.contentViewController;
        content.mainController = self;
        
    } 
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:cTabBarSegueIdentifier]) {
        return YES;
    } else if ([identifier isEqualToString:cMenuSegueIdentifier]) {
        return (_menuSegue == nil);
    } else {
        
        return YES;
    }
}

- (CGSize) calcMenuPopoverSize {
    CGFloat height = MIN(self.view.bounds.size.height, cMaxMenuPopoverHeight);    
    return CGSizeMake(cMenuPopoverWidth, height);
}

- (IBAction)searchButtonPressed:(id)sender {
    if (_searchPopover != nil)
        return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanSearchBarViewController *searchBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchBarViewController"];
    [searchBarViewController setDelegate:self];
    
    _searchPopover = [[UIPopoverController alloc]initWithContentViewController:searchBarViewController];
    _searchPopover.delegate = self;
    [_searchPopover presentPopoverFromBarButtonItem:_searchButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    [_channelPopover dismissPopoverAnimated:YES];
    _channelPopover = nil;
    [_menuSegue dismissPopoverAnimated:YES];
    _menuSegue = nil;
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _searchPopover)
        _searchPopover = nil;
    if (popoverController == _menuSegue)
        _menuSegue = nil;
    if (popoverController == _channelPopover)
        _channelPopover = nil;

}

- (void)startChannel:(ChanChannel*)channel{
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuSegue dismissPopoverAnimated:YES];
    _menuSegue = nil;
    [_channelPopover dismissPopoverAnimated:YES];
    _channelPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChannelViewController *channelViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    channelViewController.channel = channel;
    
    [[self navigationController]pushViewController:channelViewController animated:YES];
}


-(void)showChannelList{
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuSegue dismissPopoverAnimated:YES];
    _menuSegue = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *channelNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ChanChannelListViewController"];
    
    _channelPopover = [[UIPopoverController alloc]initWithContentViewController:channelNavigationController];
    _channelPopover.delegate = self;
    
    [_channelPopover presentPopoverFromBarButtonItem:_menuButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    return;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuSegue dismissPopoverAnimated:YES];
    _menuSegue = nil;
    [_channelPopover dismissPopoverAnimated:YES];
    _channelPopover = nil;
    
    NSString *searchTerm = [searchBar text];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanSearchTableViewController *searchController = [storyboard instantiateViewControllerWithIdentifier:@"ChanSearchTableViewController"];
    //searchController.delegate = self;
    
    [[self navigationController]pushViewController:searchController animated:YES];

    //  Search
    CLLocation * location = [[CLLocation alloc]initWithLatitude:1.294457 longitude:103.773956];

    [ChanEvent search:location.coordinate withinDistance:100000.0 withCompletion:^(NSArray *events, NSError *error) {
        [searchController.refreshControl endRefreshing];
        
        NSArray *channelList = events;
      //  [searchController setChannelList: channelList];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelUITableViewCell *cell = (ChannelUITableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChannelViewController *channelViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    channelViewController.channel = [[cell event]channel];
    
    [[self navigationController]pushViewController:channelViewController animated:YES];
    
}

@end
