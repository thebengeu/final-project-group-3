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

@interface ChanCollectionViewController () {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
    
}

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
	
    // Initialize posts array
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    // Change background to grey
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    // Init and update waterfall layout
    _waterfallLayout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    _waterfallLayout.delegate = self;
    _waterfallLayout.sectionInset = UIEdgeInsetsMake(10.0f, 12.0f, 0, 12.0f);
    [self updateLayout];
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
        
        [vpvc setServerURL:((ChanVideoPost *)cell.post).url];
    } else if ([segueName isEqualToString:cSlideSegue]) {
        ChanSlidesViewController *slidesViewController = (ChanSlidesViewController *)segue.destinationViewController;
        ChanSlidesCell *cell = (ChanSlidesCell *)sender;
        
        slidesViewController.post = (ChanSlidesPost *)cell.post;
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

// TODO: complete 
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
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateLayout];
}

@end
