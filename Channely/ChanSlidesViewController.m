//
//  ChanSlidesViewController.m
//  Channely
//
//  Created by Beng on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanSlidesViewController.h"
#import "ChanSlidesPost.h"
#import "ChanSlidePost.h"
#import "ChanAnnotationViewController.h"

@interface ChanSlidesViewController ()

@end

@implementation ChanSlidesViewController

#pragma mark Setters
- (void)setPost:(ChanSlidesPost *)post
{
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:urlDescriptor];
    self.slides = [[post.slides allObjects] sortedArrayUsingDescriptors:descriptors];
}

#pragma mark View Controller Methods
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
    // Do any additional setup after loading the view.
    
    //  Bar items
    NSMutableArray *rightBarItems = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Annotate" style:UIBarButtonItemStylePlain target:self action:@selector(annotate)];
    [rightBarItems addObject:doneButton];
    
    self.navigationItem.rightBarButtonItems = rightBarItems;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.delegate = self;
    self.pageWidth = self.scrollView.frame.size.width;
    self.pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(self.pageWidth * self.slides.count, self.pageHeight);
    
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pageWidth, self.pageHeight)];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView1.tag = 1;
    [self.scrollView addSubview:self.imageView1];
    
    if (self.slides.count) {
        self.selectedPage = 0;
        self.zone = 1;
        ChanSlidePost *firstSlide = [self.slides objectAtIndex:0];
        [self.imageView1 setImageWithURL:[NSURL URLWithString:firstSlide.url]];
    }
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.pageWidth, 0, self.pageWidth, self.pageHeight)];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView2.tag = 2;
    [self.scrollView addSubview:self.imageView2];
    
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.pageWidth * 2, 0, self.pageWidth, self.pageHeight)];
    self.imageView3.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView3.tag = 3;
    [self.scrollView addSubview:self.imageView3];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat oldPageWidth = self.pageWidth;
    self.pageWidth = self.scrollView.frame.size.width;
    self.pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(self.pageWidth * self.slides.count, self.pageHeight);
    self.scrollView.contentOffset = CGPointMake(self.selectedPage * self.pageWidth, self.scrollView.contentOffset.y);
    
    UIView *currentView = [self.scrollView viewWithTag:self.zone];
    currentView.frame = CGRectMake(currentView.frame.origin.x / oldPageWidth * self.pageWidth, 0, self.pageWidth, self.pageHeight);
    [self updateNextPrevImages];
}

// Use 3 UIImageViews for previous, current and next images
// Ref: http://www.cocoaintheshell.com/2011/08/efficient-gallery-like-photos-app/
- (void)updateNextPrevImages
{
    const CGFloat currPos = self.scrollView.contentOffset.x; // Get current X scrollview position
    self.selectedPage = lroundf(currPos * (1.0f / self.pageWidth)); // Compute selected page
    self.zone = 1 + (self.selectedPage % 3); // Current zone : 1 - 2 - 3
    
    const NSInteger nextPage = self.selectedPage + 1;
    const NSInteger prevPage = self.selectedPage - 1;
    
    /// Next page
    if (nextPage < self.slides.count) {
        NSInteger nextViewTag = self.zone + 1;
        if (nextViewTag == 4) nextViewTag = 1;
        UIImageView *nextView = (UIImageView *)[self.scrollView viewWithTag:nextViewTag];
        nextView.frame = CGRectMake(nextPage * self.pageWidth, 0.0f, self.pageWidth, self.pageHeight);
        ChanSlidePost *nextSlide = [self.slides objectAtIndex:nextPage];
        [nextView setImageWithURL:[NSURL URLWithString:nextSlide.url]];
    }
    /// Prev page
    if (prevPage >= 0) {
        NSInteger prevViewTag = self.zone - 1;
        if (!prevViewTag) prevViewTag = 3;
        UIImageView *prevView = (UIImageView *)[self.scrollView viewWithTag:prevViewTag];
        prevView.frame = CGRectMake(prevPage * self.pageWidth, 0.0f, self.pageWidth, self.pageHeight);
        ChanSlidePost *prevSlide = [self.slides objectAtIndex:prevPage];
        [prevView setImageWithURL:[NSURL URLWithString:prevSlide.url]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateNextPrevImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Annotation
- (void)annotate
{
    [[self delegate]launchAnnotationForImagePost:[(UIImageView *)[self.scrollView viewWithTag:self.zone] image]];
}

#pragma mark Event Handlers
- (IBAction)backButton_Action:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

@end
