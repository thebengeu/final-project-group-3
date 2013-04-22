//
//  ChannelViewController.m
//  Channely
//
//  Created by k on 25/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChannelViewController.h"
#import "ChanCreateEventViewController.h"
#import "ChanTextPostViewController.h"
#import "ChanImagePostViewController.h"
#import "ChanVideoCaptureViewController.h"
#import "SVProgressHUD.h"

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
    
    self.navigationItem.rightBarButtonItems = rightBarItems;
    // Set channel name
    self.navigationItem.title = self.channel.name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [_createEventPopover dismissPopoverAnimated:YES];
    [_imagePickerPopover dismissPopoverAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"CollectionViewSegue"]) {
        ChanCollectionViewController * childViewController = (ChanCollectionViewController *) [segue destinationViewController];
        _collectionViewController = childViewController;
        _collectionViewController.channel = self.channel;
        _collectionViewController.delegate = self;
    } else if ([segueName isEqualToString:cTakeVideoSegue]) {
        ChanVideoCaptureViewController *destination = segue.destinationViewController;
        destination.delegate = self;
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
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            [self launchImagePostSegue:image];
    }];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
        [_imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover = nil;

        if (image)
            [self launchImagePostSegue:image];
    }
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

    [self presentViewController:controller animated:YES completion:nil];
    [controller view].superview.bounds = CGRectMake(0, 0, 500, 234);
    [controller view].bounds = CGRectMake(0, 0, 500, 244);
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
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [[self navigationController]pushViewController:controller animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    
}

- (void) didFinishAnnotation:(UIImage*)image{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    
    [[self navigationController]popViewControllerAnimated:YES];
    [self launchImagePostSegue:image];
}

-(void)launchImagePostSegue: (UIImage*)image{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    ChanImagePostViewController *controller = (ChanImagePostViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ChanImagePostViewController"];
    controller.channel = _channel;
    controller.image = image;
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    [controller view].superview.bounds = CGRectMake(0, 0, 500, 290);
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
    ChannelViewController *me = self;
    [_channel addEventWithName:eventName details:description location:location startTime:startDate endTime:endDate withCompletion:^(ChanEvent *event, NSError *error) {
        [[me createEventPopover] dismissPopoverAnimated:YES];
        [SVProgressHUD setAnimationDuration:1.5];
        [SVProgressHUD showSuccessWithStatus:@"Event created"];
    }];
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
    [self.collectionViewController refreshPosts];
    [SVProgressHUD setAnimationDuration:1.5];
    [SVProgressHUD showSuccessWithStatus:@"Posted"];
}

@end
