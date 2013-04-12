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

NSString *const cTabBarSegueIdentifier = @"embeddedTabBarSegue";
NSString *const cMenuSegueIdentifier = @"popoverMenuSegue";
CGFloat const cMenuPopoverWidth = 341.;
CGFloat const cMaxMenuPopoverHeight = 704.;

@interface ChanDetailViewController ()

@property (strong) UITabBarController *_homeTabController;

@property (weak) UIPopoverController *_menuPopover;
@property UIPopoverController *searchPopover;
@property UIPopoverController *channelPopover;

- (CGSize) calcMenuPopoverSize;

@end

@implementation ChanDetailViewController
@synthesize _homeTabController;
@synthesize _menuPopover;


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
        
        if (_menuPopover != nil)
            return;
        
        _menuPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        _menuPopover.popoverContentSize = [self calcMenuPopoverSize];
        _menuPopover.delegate = self;
        ChanMenuViewController *content = (ChanMenuViewController*)_menuPopover.contentViewController;
        content.mainController = self;
        
    } 
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:cTabBarSegueIdentifier]) {
        return YES;
    } else if ([identifier isEqualToString:cMenuSegueIdentifier]) {
        return (_menuPopover == nil);
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
    [searchBarViewController searchBar].delegate = self;
    
    _searchPopover = [[UIPopoverController alloc]initWithContentViewController:searchBarViewController];
    _searchPopover.delegate = self;
    [_searchPopover presentPopoverFromBarButtonItem:self.searchButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [searchBarViewController searchBar].delegate = self;

    [_channelPopover dismissPopoverAnimated:YES];
    _channelPopover = nil;
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _searchPopover)
        _searchPopover = nil;
    if (popoverController == _menuPopover)
        _menuPopover = nil;
    if (popoverController == _channelPopover)
        _channelPopover = nil;

}

- (void)startChannel:(ChanChannel*)channel{
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    [_channelPopover dismissPopoverAnimated:YES];
    _channelPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChannelViewController *channelViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    channelViewController.channel = channel;
    
    [[self navigationController]pushViewController:channelViewController animated:YES];
}


-(void)showChannelList{
    if (_channelPopover != nil)
        return;
    
    [_searchPopover dismissPopoverAnimated:YES];
    _searchPopover = nil;
    [_menuPopover dismissPopoverAnimated:YES];
    _menuPopover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *channelNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ChanChannelListViewController"];
    
    _channelPopover = [[UIPopoverController alloc]initWithContentViewController:channelNavigationController];
    _channelPopover.delegate = self;
    
    [_channelPopover presentPopoverFromBarButtonItem:_menuButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    return;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"asd");
    NSString *searchTerm = [searchBar text];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *searchController = [storyboard instantiateViewControllerWithIdentifier:@"ChanSearchTableViewController"];
    
    [[self navigationController]pushViewController:searchController animated:YES];
}

@end
