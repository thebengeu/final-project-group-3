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
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = [self imagePreview].frame;
    frame.size.width = 1;
    [[self imagePreview]setFrame:frame];
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
    [self.channel getPostsWithCompletion:^(NSArray *posts, NSError *error) {
        [self setPosts:[NSMutableArray arrayWithArray:posts]];
        [_postTableViewController setPostList:[self posts]];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"PostTableSegue"]) {
        ChannelPostTableViewController * childViewController = (ChannelPostTableViewController *) [segue destinationViewController];
        _postTableViewController = childViewController;
        [[_postTableViewController tableView]reloadData];
        [_postTableViewController setPostList:[self posts]];
    }
      
}

- (IBAction)pickImage:(id)sender {
    [self presentImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

- (IBAction)takePhoto:(id)sender {
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

- (IBAction)sendPost:(id)sender {
}

- (void) presentImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIButton*)sender
{
    if (!self.imagePickerPopover && [UIImagePickerController isSourceTypeAvailable:sourceType]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]){
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString*)kUTTypeImage];
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
    self.imagePickerPopover = nil;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
        image = info[UIImagePickerControllerOriginalImage];
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end
