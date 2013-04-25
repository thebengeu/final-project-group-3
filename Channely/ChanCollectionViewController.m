//
//  ChanCollectionViewController.m
//  Channely
//
//  Created by Cedric on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanCollectionViewController.h"
#import "ChanCollectionView.h"
#import "ChanRefreshControl.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "ChanViewTextPostViewController.h"
#import "ChanViewImagePostViewController.h"
#import "ChanChannel.h"
#import "ChanTextCell.h"
#import "ChanImageCell.h"
#import "ChanVideoCell.h"
#import "ChanSlidesCell.h"
#import "ChanTwitterCell.h"
#import "ChanPost.h"
#import "ChanTextPost.h"
#import "ChanImagePost.h"
#import "ChanVideoPost.h"
#import "ChanVideoThumbnailPost.h"
#import "ChanSlidesPost.h"
#import "ChanTwitterPost.h"
#import "ChanVideoPlayerViewController.h"
#import "ChanSlidesViewController.h"
#import "ChannelViewControllerDelegate.h"
#import "AwesomeMenuItem.h"

@interface ChanCollectionViewController ()

@property (nonatomic, weak) IBOutlet UICollectionViewWaterfallLayout *waterfallLayout;

@property BOOL awesomeMenuIsOpen;

@property BOOL awesomeMenuShouldReopen;

@end

@implementation ChanCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background image
    UIImage *collectionBg = [[UIImage imageNamed:@"collectionbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:collectionBg];
    
    // Init and update waterfall layout
    _waterfallLayout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    _waterfallLayout.delegate = self;
    _waterfallLayout.sectionInset = UIEdgeInsetsMake(10.0f, 12.0f, 15.0f, 12.0f);
    [self updateLayout];
    
    // Add post button
    [self addPostControl];
    
    self.refreshControl = [ChanRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshPosts)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Posts"];
    [self.collectionView addSubview:self.refreshControl];
    
    // Setup time scroller
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLayout];
    [self refreshPosts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopRefreshingPosts];
    [SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:kVideoPlayerSegue]) {
        ChanVideoPlayerViewController *vpvc = (ChanVideoPlayerViewController *)segue.destinationViewController;
        ChanVideoCell *cell = (ChanVideoCell *)sender;
        
        [vpvc setServerURL:((ChanVideoPost *)cell.post).url forChannel:cell.post.channel];
        vpvc.delegate = self.delegate;
    } else if ([segueName isEqualToString:kSlideSegue]) {
        ChanSlidesViewController *slidesViewController = (ChanSlidesViewController *)segue.destinationViewController;
        ChanSlidesCell *cell = (ChanSlidesCell *)sender;
        
        slidesViewController.channel = self.channel;
        slidesViewController.post = (ChanSlidesPost *)cell.post;
        slidesViewController.delegate = self.delegate;
    } else if ([segueName isEqualToString:kTextSegue]) {
        ChanViewTextPostViewController *textViewController = (ChanViewTextPostViewController *)segue.destinationViewController;
        
        ChanTextCell *cell = (ChanTextCell *)sender;
        textViewController.post = (ChanPost *)cell.post;
    } else if ([segueName isEqualToString:kImageSegue]) {
        ChanViewImagePostViewController *imageViewController = (ChanViewImagePostViewController *)segue.destinationViewController;
        
        ChanTextCell *cell = (ChanTextCell *)sender;
        imageViewController.post = (ChanPost *)cell.post;
        imageViewController.delegate = self.delegate;
    } else if ([segueName isEqualToString:kTweetSegue]) {
        ChanViewTextPostViewController *textViewController = (ChanViewTextPostViewController *)segue.destinationViewController;
        
        ChanTwitterCell *cell = (ChanTwitterCell *)sender;
        textViewController.post = (ChanPost *)cell.post;
    }
}

- (void)refreshPosts
{
    [self refreshTwitterPosts];
    [self.channel getPostsSince:self.channel.lastRefreshed until:nil withCompletion:^(NSArray *posts, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if (posts.count) {
            ChanPost *post = (ChanPost *)[posts lastObject];
            self.channel.lastRefreshed = post.createdAt;
        }
        
        // Refresh posts after kPostsRefreshInterval seconds
        [self stopRefreshingPosts];
        [self performSelector:@selector(refreshPosts) withObject:nil afterDelay:kPostsRefreshIntervalSecs];
    }];
}

- (void)stopRefreshingPosts
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPosts) object:nil];
}

- (void)refreshTwitterPosts
{
    NSDateComponents *components;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if (self.twitterLastRefreshed) {
        components = [calendar components:NSSecondCalendarUnit fromDate:self.twitterLastRefreshed toDate:now options:0];
    }
    
    if (!self.twitterLastRefreshed || components.second >= kTwitterRefreshIntervalSecs) {
        self.twitterLastRefreshed = now;
        [self.channel getTweetsWithCompletion:nil];
    }
}

- (Class)cellClassForPost:(ChanPost *)post
{
    switch (post.typeConstant) {
        case kTextPost:
            return ChanTextCell.class;
        case kImagePost:
            return ChanImageCell.class;
        case kVideoPost:
            return ChanVideoCell.class;
        case kSlidesPost:
            return ChanSlidesCell.class;
        case kTwitterPost:
            return ChanTwitterCell.class;
        default:
            NSLog(kUnexpectedTypeConstantMessage, post.typeConstant);
            return nil;
    }
}

- (NSString *)reuseIdentifierForPost:(ChanPost *)post
{
    switch (post.typeConstant) {
        case kTextPost:
            return @"TextCell";
        case kImagePost:
            return @"ImageCell";
        case kVideoPost:
            return @"VideoCell";
        case kSlidesPost:
            return @"SlidesCell";
        case kTwitterPost:
            return @"TwitterCell";
        default:
            NSLog(kUnexpectedTypeConstantMessage, post.typeConstant);
            return nil;
    }
}

#pragma mark Create Menu functions

// Set up the awesome menu for creating posts
- (void)addPostControl
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem@2x.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted@2x.png"];
    
    UIImage *textMenuImage = [UIImage imageNamed:@"text_menu_icon"];
    UIImage *pictureMenuImage = [UIImage imageNamed:@"picture_menu_icon"];
    UIImage *galleryMenuImage = [UIImage imageNamed:@"gallery_menu_icon"];
    UIImage *videoMenuImage = [UIImage imageNamed:@"video_menu_icon"];
    
    AwesomeMenuItem *textMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:textMenuImage
                                                   highlightedContentImage:nil];
    
    AwesomeMenuItem *pictureMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:pictureMenuImage highlightedContentImage:nil];
    
    AwesomeMenuItem *videoMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:videoMenuImage highlightedContentImage:nil];
    
    AwesomeMenuItem *galleryMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:galleryMenuImage highlightedContentImage:nil];
    
    _createPostMenu = [[AwesomeMenu alloc] initWithFrame:self.view.window.bounds menus:[NSArray arrayWithObjects:textMenuItem, galleryMenuItem, pictureMenuItem, videoMenuItem, nil]];
    
    _createPostMenu.delegate = self;
    
    _createPostMenu.startPoint = [self getCreateMenuStartPoint:self.interfaceOrientation];
    _createPostMenu.rotateAngle = M_PI * 23 / 16; // Menu location
    _createPostMenu.menuWholeAngle = M_PI * 6 / 7; // Menu span
    _createPostMenu.endRadius = 140.0f; // Radius of expanded menu
    // Bounce animation
    _createPostMenu.farRadius = 160.0f;
    _createPostMenu.nearRadius = 120.0f;
    
    _createPostMenu.layer.zPosition = 100;
    
    [self.view addSubview:_createPostMenu];
}

// Returns the Create Menu's origin point given the UIInterfaceOrientation
- (CGPoint)getCreateMenuStartPoint:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGPointMake(kPostMenuLandscapeX, kPostMenuLandscapeY);
    } else {
        return CGPointMake(kPostMenuPortraitX, kPostMenuPortraitY);
    }
}

#pragma mark - Collection View Protocol methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSUInteger numberOfObjects = [sectionInfo numberOfObjects];
    
    if (numberOfObjects == 0) {
        [SVProgressHUD show];
    } else {
        [SVProgressHUD dismiss];
    }
    
    return numberOfObjects;
}

// UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ChanAbstractCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseIdentifierForPost:post] forIndexPath:indexPath];
    cell.post = post;
    return cell;
}

#pragma mark - Time Scroller methods

- (UICollectionView *)collectionViewForTimeScroller:(TimeScroller *)timeScroller
{
    return self.collectionView;
}

- (NSDate *)dateForCell:(UICollectionViewCell *)cell
{
    ChanAbstractCell *tempCell = (ChanAbstractCell *)cell;
    return tempCell.post.createdAt;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibles = [self.collectionView visibleCells];
    if (visibles.count != 0) {
        UICollectionViewCell *cell = (UICollectionViewCell *)visibles[visibles.count / 2];
        [_timeScroller scrollViewDidScroll:cell];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}

#pragma mark - Waterfall Layout methods

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat height = [[self cellClassForPost:post] getHeightForPost:post];
    
    ChanCollectionView *chanCollectionView = (ChanCollectionView *)collectionView;
    if (height > chanCollectionView.maxCellHeight) {
        chanCollectionView.maxCellHeight = height;
    }
    
    return height;
}

// Used for updating the layout of the collection view when screen orientation changes, etc
- (void)updateLayout
{
    _waterfallLayout.columnCount = self.collectionView.bounds.size.width / kCellWidth;
    _waterfallLayout.itemWidth = kCellWidth;
    _createPostMenu.startPoint = [self getCreateMenuStartPoint:self.interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateLayout];
    if (_awesomeMenuIsOpen == YES) {
        _awesomeMenuShouldReopen = YES;
        [_createPostMenu setExpanding:NO];
    } else _awesomeMenuShouldReopen = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (_awesomeMenuShouldReopen) {
        [_createPostMenu setExpanding:YES];
    }
}

#pragma mark AwesomeMenu Delegate
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case kTextMenuItem: // Text Post
            [_delegate launchTextPostSegue];
            break;
        case kPictureMenuItem: // Gallery Post
            [_delegate launchImagePicker:_createPostMenu.addButton.frame];
            break;
        case kVideoMenuItem: // Camera
            [_delegate launchCameraForImage];
            break;
        case kGalleryMenuItem: // Video
            [_delegate launchVideoSegue];
            break;
        default:
            break;
    }
}

- (void)AwesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    _awesomeMenuIsOpen = NO;
}

- (void)AwesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
    _awesomeMenuIsOpen = YES;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    self.managedObjectContext = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel == %@ AND (type = %@ OR type = %@ OR type = %@ OR type = %@ OR type = %@)", self.channel, @"text", @"image", @"video", @"slides", @"twitter"];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:50];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

@end
