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


@interface ChannelViewController () <UIPopoverControllerDelegate>

@property UIPopoverController *imagePickerPopover;

@property UIPopoverController *attachPickerPopover;

@property AttachPickerViewController *attachPickerViewController;

@property UIImage *attachedImage;

@property UILongPressGestureRecognizer *attachButtonLongPressGestureRecognizer;

@property UIAlertView *deleteAttachmentAlertView;

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

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", self.channel.name);
    [self populateChannelPost];
    //[self populateFakePosts];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSManagedObjectContext *moc = [[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"channel == %@", self.channel];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    self.posts = [NSMutableArray arrayWithArray:[moc executeFetchRequest:request error:&error]];
    if (self.posts == nil) {
        self.posts = [NSMutableArray array];
    }
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(populateChannelPost) forControlEvents:UIControlEventValueChanged];
    _postTableViewController.refreshControl = refreshControl;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}


- (void)populateFakePosts{
    ChanUser *user1 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    //[user1 setId:@"userid1"];
    [user1 setName:@"User 1"];
    
    ChanUser *user2 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    //[user2 setId:@"userid2"];
    [user2 setName:@"User 2"];
    
    //  Posts
    NSMutableArray *posts = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <20; i++){
        ChanPost *post;
        if (i % 5 != 0){
            post = [NSEntityDescription insertNewObjectForEntityForName:@"TextPost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
            post.content = [NSString stringWithFormat:@"text %d", i];
            [post setCreatedAt:[NSDate date]];
            
            if (i % 3 == 0)
                [post setCreator:user1];
            else
                [post setCreator:user2];
        } else {
            post = [NSEntityDescription insertNewObjectForEntityForName:@"ImagePost" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
            post.content = [NSString stringWithFormat:@"image %d", i];
            [(ChanImagePost*)post setUrl:@"http://www.earthtimes.org/newsimage/eating-apples-extended-lifespan-test-animals-10-per-cent_183.jpg"];
            [post setCreatedAt:[NSDate date]];
            
            if (i % 3 == 0)
                [post setCreator:user1];
            else
                [post setCreator:user2];
        }
        [posts addObject:post];
    }
    [self setPosts:posts];
    [_postTableViewController setPostList:[self posts]];
}

-(void)populateChannelPost
{
    [self.channel getPostsSince:self.channel.lastRefreshed until:nil withCompletion:^(NSArray *posts, NSError *error) {
        [_postTableViewController.refreshControl endRefreshing];
        
        self.channel.lastRefreshed = [NSDate date];
        [self.posts addObjectsFromArray:posts];
        [_postTableViewController setPostList:self.posts];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"PostTableSegue"]) {
        ChannelPostTableViewController * childViewController = (ChannelPostTableViewController *) [segue destinationViewController];
        _postTableViewController = childViewController;
//        [[_postTableViewController tableView]reloadData];
//        [_postTableViewController setPostList:[self posts]];
    }
      
}

- (void)pickImage:(id)sender {
    [_attachPickerPopover dismissPopoverAnimated:NO];
    _attachPickerPopover = nil;
    [self presentPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:_attachButton type:@[(NSString*) kUTTypeImage]];
}

- (void)takePhoto:(id)sender {
    [_attachPickerPopover dismissPopoverAnimated:NO];
    _attachPickerPopover = nil;
    [self presentPicker:UIImagePickerControllerSourceTypeCamera sender:_attachButton type:nil];
}

-(void)pickVideo:(id)sender {
    [_attachPickerPopover dismissPopoverAnimated:NO];
    _attachPickerPopover = nil;
    [self presentPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:_attachButton type:@[(NSString*) kUTTypeMovie]];
}

- (IBAction)attach:(id)sender {
    if(!_attachPickerPopover && !_attachedImage) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        _attachPickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"AttachPickerViewController"];
        [_attachPickerViewController setDelegate:self];
        _attachPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_attachPickerViewController];
        [_attachPickerPopover setDelegate:self];
        [_attachPickerPopover presentPopoverFromRect:_attachButton.frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)sendPost:(id)sender {
    [_sendPostIndicator startAnimating];
    [_textInput setEditable:NO];
    ChannelViewController *channelViewController = self;
    if (_attachedImage == nil){
        [_channel addTextPostWithContent:[_textInput text] withCompletion:^(ChanTextPost *textPost, NSError *error) {
            [[channelViewController textInput]setText:@""];
            [[channelViewController sendPostIndicator]stopAnimating];
            [[channelViewController textInput] setEditable:YES];
            [channelViewController populateChannelPost];
        }];
    } else {
        [_channel addImagePostWithContent:[_textInput text] image:_attachedImage withCompletion:^(ChanImagePost *imagePost, NSError *error) {
            [[channelViewController textInput]setText:@""];
            [[channelViewController sendPostIndicator]stopAnimating];
            [[channelViewController textInput] setEditable:YES];
            [channelViewController setAttachedImage:nil];
            [channelViewController changeAttachButtonToDefault];
            [channelViewController populateChannelPost];
        }];
    }
}

// Based on type, displays image picker, video picker, or camera
- (void) presentPicker:(UIImagePickerControllerSourceType)sourceType sender:(UIButton*)sender type:(NSArray*) type
{
    if (!self.imagePickerPopover && [UIImagePickerController isSourceTypeAvailable:sourceType]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = sourceType;
            
            if (type) picker.mediaTypes = type;
            else picker.mediaTypes = @[(NSString*) kUTTypeImage];
            
            picker.allowsEditing = NO;
            picker.delegate = self;
            
            if ((sourceType != UIImagePickerControllerSourceTypeCamera) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)){
                
                self.imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:picker];
                [self.imagePickerPopover presentPopoverFromRect:sender.frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.imagePickerPopover.delegate = self;
                
            } else {
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == _imagePickerPopover)
        _imagePickerPopover = nil;
    else if (popoverController == _attachPickerPopover)
        _attachPickerPopover = nil;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _attachedImage = image;
    [self changeAttachButtonToAttached];
}

-(void)changeAttachButtonToAttached{
    [_attachButton setBackgroundImage:_attachedImage forState:UIControlStateNormal];
    [_attachButton setTitle:@"" forState:UIControlStateNormal];
    
    //  Delete gesture
    _attachButtonLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(confirmRemoveAttachedImage)];
    [_attachButtonLongPressGestureRecognizer setMinimumPressDuration:1];
    [_attachButton addGestureRecognizer:_attachButtonLongPressGestureRecognizer];
}

-(void)changeAttachButtonToDefault{
    [_attachButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_attachButton setTitle:@"Attach" forState:UIControlStateNormal];
    if (_attachButtonLongPressGestureRecognizer != nil){
        [_attachButton removeGestureRecognizer:_attachButtonLongPressGestureRecognizer];
        _attachButtonLongPressGestureRecognizer = nil;
        [_attachButton setSelected:NO];
        [_attachButton setHighlighted:NO];
    }
}

-(void)confirmRemoveAttachedImage{
    if (_deleteAttachmentAlertView == nil){
        _deleteAttachmentAlertView = [[UIAlertView alloc] initWithTitle:@"Attachment"
                                                    message:@"Delete the attachment?"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:@"Cancel", nil];
        [_deleteAttachmentAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_deleteAttachmentAlertView == alertView){
        if (buttonIndex == 0)
            [self changeAttachButtonToDefault];
        _deleteAttachmentAlertView = nil;
        _attachedImage = nil;
    }
}


-(void)keyboardDidShow: (NSNotification*)aNotification {
    // Animate the current view out of the way
    CGRect frame = [self view].frame;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
        frame.origin.y -= kbSize.width;
    else
        frame.origin.y -= kbSize.height;
    [[self view]setFrame:frame];
}

-(void)keyboardDidHide: (NSNotification*)aNotification  {
    // Animate the current view out of the way
    CGRect frame = [self view].frame;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
        frame.origin.y += kbSize.width;
    else
        frame.origin.y += kbSize.height;
    [[self view]setFrame:frame];
}




@end
