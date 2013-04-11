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

@interface ChanSlidesViewController ()

@end

@implementation ChanSlidesViewController

#pragma mark Setters
- (void)setPost:(ChanSlidesPost *)post
{
    NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:urlDescriptor];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollView.delegate = self;
    self.pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(self.pageWidth * self.slides.count, pageHeight);
    
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pageWidth, pageHeight)];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView1.tag = 1;
    [self.scrollView addSubview:self.imageView1];
    
    if (self.slides.count) {
        ChanSlidePost* firstSlide = [self.slides objectAtIndex:0];
        [self.imageView1 setImageWithURL:[NSURL URLWithString:firstSlide.url]];
    }
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.pageWidth, 0, self.pageWidth, pageHeight)];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView2.tag = 2;
    [self.scrollView addSubview:self.imageView2];
    
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.pageWidth * 2, 0, self.pageWidth, pageHeight)];
    self.imageView3.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView3.tag = 3;
    [self.scrollView addSubview:self.imageView3];
}

// Use 3 UIImageViews for previous, current and next images
// Ref: http://www.cocoaintheshell.com/2011/08/efficient-gallery-like-photos-app/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    const CGFloat currPos = scrollView.contentOffset.x; // Get current X scrollview position
    const NSInteger selectedPage = lroundf(currPos * (1.0f / self.pageWidth)); // Compute selected page
    const NSInteger zone = 1 + (selectedPage % 3); // Current zone : 0 - 1 - 2
    
    const NSInteger nextPage = selectedPage + 1;
    const NSInteger prevPage = selectedPage - 1;
    
    /// Next page
    if (nextPage < self.slides.count)
    {
        NSInteger nextViewTag = zone + 1;
        if (nextViewTag == 4)
            nextViewTag = 1;
        UIImageView* nextView = (UIImageView*)[scrollView viewWithTag:nextViewTag];
        nextView.frame = (CGRect){.origin.x = nextPage * self.pageWidth, .origin.y = 0.0f, .size = nextView.frame.size};
        ChanSlidePost* nextSlide = [self.slides objectAtIndex:nextPage];
        [nextView setImageWithURL:[NSURL URLWithString:nextSlide.url]];
    }
    /// Prev page
    if (prevPage >= 0)
    {
        NSInteger prevViewTag = zone - 1;
        if (!prevViewTag)
            prevViewTag = 3;
        UIImageView* prevView = (UIImageView*)[scrollView viewWithTag:prevViewTag];
        prevView.frame = (CGRect){.origin.x = prevPage * self.pageWidth, .origin.y = 0.0f, .size = prevView.frame.size};
        ChanSlidePost* prevSlide = [self.slides objectAtIndex:prevPage];
        [prevView setImageWithURL:[NSURL URLWithString:prevSlide.url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Event Handlers
- (IBAction) backButton_Action:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

@end
