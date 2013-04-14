//
//  ChanCollectionViewController.m
//  Channely
//
//  Created by Cedric on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanCollectionViewController.h"

static CGFloat const kCellWidth = 240;
static NSString *const cVideoPlayerSegue = @"videoPlayerSegue";
static NSString *const cSlideSegue = @"slidesSegue";
static CGFloat const kPostMenuLandscapeX = 955.0;
static CGFloat const kPostMenuLandscapeY = 645.0;
static CGFloat const kPostMenuPortraitX = 700.0;
static CGFloat const kPostMenuPortraitY = 900.0;

@interface ChanCollectionViewController ()

@property (nonatomic, weak) IBOutlet UICollectionViewWaterfallLayout *waterfallLayout;

@end

@implementation ChanCollectionViewController

- (void)setPosts:(NSArray *)posts
{
    _posts = posts;
    [self.collectionView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString:cVideoPlayerSegue]) {
        ChanVideoPlayerViewController *vpvc = (ChanVideoPlayerViewController *)segue.destinationViewController;
        ChanVideoCell *cell = (ChanVideoCell *)sender;
        
        [vpvc setServerURL:((ChanVideoPost *)cell.post).url forChannel:cell.post.channel];
    } else if ([segueName isEqualToString:cSlideSegue]) {
        ChanSlidesViewController *slidesViewController = (ChanSlidesViewController *)segue.destinationViewController;
        ChanSlidesCell *cell = (ChanSlidesCell *)sender;
        
        slidesViewController.channel = self.channel;
        slidesViewController.post = (ChanSlidesPost *)cell.post;
    }
}

#pragma mark Create Menu functions

// Set up the awesome menu for creating posts
- (void) addPostControl
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
    _createPostMenu.rotateAngle = M_PI * 23/16; // Menu location
    _createPostMenu.menuWholeAngle = M_PI * 6/7; // Menu span
    _createPostMenu.endRadius = 140.0f; // Radius of expanded menu
    // Bounce animation
    _createPostMenu.farRadius = 160.0f;
    _createPostMenu.nearRadius = 120.0f;
    
    _createPostMenu.layer.zPosition = 100;
    
    [self.view addSubview:_createPostMenu];
}

// Returns the Create Menu's origin point given the UIInterfaceOrientation
- (CGPoint)getCreateMenuStartPoint: (UIInterfaceOrientation) interfaceOrientation
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
    return self.posts.count;
}

// UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChanAbstractCell *cell;
    
    ChanPost *post = [self.posts objectAtIndex:indexPath.row];
    Class postClass = [post class];

    if (postClass == [ChanTextPost class]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextCell" forIndexPath:indexPath];
    } else if (postClass == [ChanImagePost class]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    } else if (postClass == [ChanVideoPost class]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    } else if (postClass == [ChanSlidesPost class]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SlidesCell" forIndexPath:indexPath]; 
    }
    
    cell.post = post;
    return cell;
}

#pragma mark - Waterfall Layout methods

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPost *post = [self.posts objectAtIndex:indexPath.row];
    Class postClass = [post class];
    
    if (postClass == [ChanTextPost class]) {
        return [ChanTextCell getHeightForPost:post];
    } else if (postClass == [ChanImagePost class]) {
        return [ChanImageCell getHeightForPost:post];
    } else if (postClass == [ChanVideoPost class]) {
        return [ChanVideoCell getHeightForPost:post];
    } else if (postClass == [ChanSlidesPost class]) {
        return [ChanSlidesCell getHeightForPost:post];
    } else {
        return 0;
    }
}

// Used for updating the layout of the collection view when screen orientation changes, etc
-(void)updateLayout
{
    _waterfallLayout.columnCount = self.collectionView.bounds.size.width / kCellWidth;
    _waterfallLayout.itemWidth = kCellWidth;
    _createPostMenu.startPoint = [self getCreateMenuStartPoint:self.interfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateLayout];
}

#pragma mark AwesomeMenu Delegate
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0: // Text Post
            break;
        case 1: // Gallery Post
            break;
        case 2: // Camera 
            break;
        case 3: // Video
            [_delegate launchVideoSegue];
            break;
        default:
            break;
    }
        
    NSLog(@"Select the index : %d",idx);
}

@end
