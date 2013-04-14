//
//  ChanAnnotationViewController.m
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAnnotationViewController.h"
#import "ChanAnonUser.h"

@interface ChanAnnotationViewController ()

@end

@implementation ChanAnnotationViewController

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
    
    //  Keyboard
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    
    //  Set images and annotation view
    [_imageView setImage:_image];  
}

-(void)viewDidAppear:(BOOL)animated{
    _annotationView = [[AnnotationUIView alloc]initWithFrame:[_imageView frame]];
    [_annotationView setMarkerColor:[UIColor redColor]];
    [[self view]addSubview:_annotationView];
    [[self view]bringSubviewToFront:_annotationView];
    [[self view]setContentMode:UIViewContentModeScaleAspectFit];
}


-(UIImage*)mergeAnnotation{
    UIGraphicsBeginImageContext(_annotationView.frame.size);
    [_image drawInRect:CGRectMake(0,0,_annotationView.frame.size.width,_annotationView.frame.size.height)];
    [[_annotationView screenshot] drawInRect:CGRectMake(0,0,_annotationView.frame.size.width,_annotationView.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (IBAction)done:(id)sender {
    id me = self;
    [_channel addImagePostWithContent:[_textContent text] username:[ChanAnonUser name] image:[self mergeAnnotation] withCompletion:^(ChanImagePost *imagePost, NSError *error){
        [me dismissViewControllerAnimated:YES completion:nil];
    }];
}




-(void)keyboardDidShow: (NSNotification*)aNotification {
    // Animate the current view out of the way
    CGRect frame = [self view].frame;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (UIDeviceOrientationFaceDown == self.interfaceOrientation)
        frame.origin.y -= kbSize.height;
    else if (UIDeviceOrientationFaceUp == self.interfaceOrientation)
        frame.origin.y += kbSize.height;
    else if (UIDeviceOrientationLandscapeLeft == self.interfaceOrientation)
        frame.origin.x += kbSize.width;
    else if (UIDeviceOrientationLandscapeRight == self.interfaceOrientation)
        frame.origin.x -= kbSize.width;

    [[self view]setFrame:frame];
}

-(void)keyboardDidHide: (NSNotification*)aNotification  {
    // Animate the current view out of the way
    CGRect frame = [self view].frame;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (UIDeviceOrientationFaceDown == self.interfaceOrientation)
        frame.origin.y += kbSize.height;
    else if (UIDeviceOrientationFaceUp == self.interfaceOrientation)
        frame.origin.y -= kbSize.height;
    else if (UIDeviceOrientationLandscapeLeft == self.interfaceOrientation)
        frame.origin.x -= kbSize.width;
    else if (UIDeviceOrientationLandscapeRight == self.interfaceOrientation)
        frame.origin.x += kbSize.width;
    [[self view]setFrame:frame];
}





- (IBAction)redColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor redColor]];
}

- (IBAction)greenColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor greenColor]];
}

- (IBAction)blueColor:(id)sender {
    [_annotationView setMarkerColor:[UIColor blueColor]];
}

- (IBAction)clear:(id)sender {
    [_annotationView clear];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
