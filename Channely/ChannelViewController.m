//
//  ChannelViewController.m
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelViewController.h"
#import "ChanChannel.h"
#import "ChanUser.h"
#import "ChanPost.h"
#import "ChanImagePost.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ChanCreateEventViewController.h"
#import "ChanEvent.h"
#import "UIImage+normalizedOrientation.h"
#import "ChanAnonUser.h"
#import "ChanTextPostViewController.h"
#import "ChanImagePostViewController.h"
#import "ChanVideoCaptureViewController.h"
#import "ChanAnnotationViewController.h"

static NSString *const cTakeVideoSegue = @"takeVideoSegue";

@interface ChannelViewController () <UIPopoverControllerDelegate>

@property UIPopoverController *imagePickerPopover;

@property UIPopoverController *createEventPopover;
@property UIBarButtonItem *createEventButton;
@property UIBarButtonItem *toggleButton;
@property ChanCreateEventViewController *createEventViewController;
@property UIView *currentContent;

@end


@implementation ChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

# pragma mark View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Bar items
    NSMutableArray *rightBarItems = [[NSMutableArray alloc]init];
    
    // If owner, show create event button
    if ([[ChanUser loggedInUser].id compare:[_channel owner].id] == NSOrderedSame && [ChanUser loggedInUser].id != nil){
        _createEventButton = [[UIBarButtonItem alloc]initWithTitle:@"Create Event" style:UIBarButtonItemStylePlain target:self action:@selector(createEventButtonPressed)];
        [rightBarItems addObject:_createEventButton];
    }
    
    //  Add more items if needed
    _toggleButton = [[UIBarButtonItem alloc]initWithTitle:@"Temporal" style:UIBarButtonItemStylePlain target:self action:@selector(toggleChannelLayout)];
    [rightBarItems addObject:_toggleButton];

    self.navigationItem.rightBarButtonItems = rightBarItems;
    // Set channel name
    self.navigationItem.title = self.channel.name;
}


-(void)viewDidAppear:(BOOL)animated{
    //  Load contents
    [self toggleChannelLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [_createEventPopover dismissPopoverAnimated:YES];
}

# pragma mark Orientation Handlers

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                                                duration:duration];
    [_collectionViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
}

// Select the right layout to use for the channel
-(void) toggleChannelLayout{
    CGRect frame = [self contentContainer].frame;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    if (_currentContent == [_collectionViewController view] && _currentContent != nil){
        //  To change to ChanCollectionViewController

        if (_postTableViewController == nil){
            _postTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChannelPostTableViewController"];
            UIRefreshControl *refreshControl = [UIRefreshControl new];
            [refreshControl addTarget:self action:@selector(populateChannelPost) forControlEvents:UIControlEventValueChanged];
            _postTableViewController.refreshControl = refreshControl;
        }
        
        [_currentContent removeFromSuperview];
        _currentContent = [_postTableViewController view];
        [_toggleButton setTitle:@"Collection"];
       
    } else {
        //  to change to ChannelPostTableViewController
        
        if (_collectionViewController == nil)
            _collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChanCollectionViewController"];
        
        _collectionViewController.channel = self.channel;
        _collectionViewController.posts = self.posts;
        _collectionViewController.delegate = self;
        
        [_currentContent removeFromSuperview];
        _currentContent = [_collectionViewController view];
        [_toggleButton setTitle:@"Temporal"];
    }
    
    [self populateChannelPost];
    _currentContent.frame = frame;
    [[self view]addSubview:_currentContent];
}

-(void)populateChannelPost
{
    [self.channel getPostsSince:self.channel.lastRefreshed until:nil withCompletion:^(NSArray *posts, NSError *error) {
        [_postTableViewController.refreshControl endRefreshing];
        
        if (posts.count) {
            ChanPost *post = (ChanPost *)[posts lastObject];
            self.channel.lastRefreshed = post.createdAt;
        }

        NSManagedObjectContext *moc = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"channel == %@ AND (type = %@ OR type = %@ OR type = %@ OR type = %@)", self.channel, @"text", @"image", @"video", @"slides"];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSError *err;
        self.posts = [NSMutableArray arrayWithArray:[moc executeFetchRequest:request error:&err]];
        
        _postTableViewController.postList = self.posts;
        _collectionViewController.posts = self.posts;
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"PostTableSegue"]) {
        ChannelPostTableViewController * childViewController = (ChannelPostTableViewController *) [segue destinationViewController];
        _postTableViewController = childViewController;
//        [[_postTableViewController tableView]reloadData];
//        [_postTableViewController setPostList:[self posts]];
    } else if ([segueName isEqualToString:cTakeVideoSegue]) {
        ChanVideoCaptureViewController *destination = segue.destinationViewController;
        
        destination.parentChannel = [self underlyingChannel];
    }
      
}

#pragma mark Post Creation Controls


// Based on type, displays image picker, video picker, or camera
- (void) presentPicker:(UIImagePickerControllerSourceType)sourceType sender:(UIButton*)sender type:(NSArray*) type
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = sourceType;
            
            if (type) picker.mediaTypes = type;
            else picker.mediaTypes = @[(NSString*) kUTTypeImage];
            
            picker.allowsEditing = NO;
            picker.delegate = self;
            
            if ((sourceType != UIImagePickerControllerSourceTypeCamera) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
                if (self.imagePickerPopover == nil){
                    self.imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:picker];
                    [self.imagePickerPopover presentPopoverFromRect:sender.frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    self.imagePickerPopover.delegate = self;
                }
                
            } else {
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
        if (image)
            [self launchImagePostSegue:image];
    }];
}


- (void)launchVideoSegue
{
    [self performSegueWithIdentifier:cTakeVideoSegue sender:self];
}

- (void)launchTextPostSegue
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanTextPostViewController *controller = (ChanTextPostViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ChanTextPostViewController"];
    controller.channel = _channel;
    controller.delegate = self;

    [self presentViewController:controller animated:NO completion:nil];
    [controller view].superview.bounds = CGRectMake(0, 0, 500, 300);
    [controller view].bounds = CGRectMake(0, 0, 500, 300);
}

- (void)launchImagePicker
{
    [self presentPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:_attachButton type:@[(NSString*) kUTTypeImage]];
}


- (void)launchCameraForImage
{
    [self presentPicker:UIImagePickerControllerSourceTypeCamera sender:_attachButton type:nil];
}

- (void)launchAnnotationForImagePost:(UIImage*)image{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanAnnotationViewController *controller = (ChanAnnotationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ChanAnnotationViewController"];
    [controller setImage:image];
    controller.delegate = self;
    
    [self presentViewController:controller animated:NO completion:nil];
}

- (void) didFinishAnnotation:(UIImage*)image{
    [self launchImagePostSegue:image];
}

-(void)launchImagePostSegue: (UIImage*)image{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanImagePostViewController *controller = (ChanImagePostViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ChanImagePostViewController"];
    controller.channel = _channel;
    controller.image = image;
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    [controller view].superview.bounds = CGRectMake(0, 0, 500, 300);
    [controller view].bounds = CGRectMake(0, 0, 500, 300);
}



#pragma mark Event Creation Controls

-(void)createEventButtonPressed{
    if (_createEventPopover != nil)
        return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    _createEventViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChanCreateEventViewController"];
    [_createEventViewController setDelegate:self];
    
    _createEventPopover = [[UIPopoverController alloc]initWithContentViewController:_createEventViewController];
    _createEventPopover.delegate = self;
    [_createEventPopover presentPopoverFromBarButtonItem:_createEventButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) createEventWithEventName:(NSString*)eventName startDate:(NSDate*)startDate endDate:(NSDate*)endDate description:(NSString*)description location:(CLLocationCoordinate2D)location{
    //NSLog(@"To create Event: %@ %f %f %@ %@ %@", eventName, lat, lon, description, startDate, endDate);
    [_channel addEventWithName:eventName details:description location:location startTime:startDate endTime:endDate withCompletion:nil];
}

- (ChanChannel *) underlyingChannel {
    return self.channel;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if (popoverController == self.imagePickerPopover)
        self.imagePickerPopover = nil;
    if (popoverController == self.createEventPopover)
        self.createEventPopover = nil;
}

- (void)didPost:(ChanChannel *)channel{
    [self populateChannelPost];
}

@end
