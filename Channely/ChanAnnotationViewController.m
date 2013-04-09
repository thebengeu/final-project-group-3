//
//  ChanAnnotationViewController.m
//  Channely
//
//  Created by k on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChanAnnotationViewController.h"

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

    
    //  Palette
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setRed)];
    [touch setNumberOfTapsRequired:1];
    [_redColor addGestureRecognizer:touch];
    [_redColor setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *touch2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setGreen)];
    [touch2 setNumberOfTapsRequired:1];
    [_greenColor addGestureRecognizer:touch2];
    [_greenColor setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *touch3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setBlue)];
    [touch3 setNumberOfTapsRequired:1];
    [_blueColor addGestureRecognizer:touch3];
    [_blueColor setUserInteractionEnabled:YES];

    
    //  Set images and annotation view
    [_imageView setImage:_image];
    
    //  [_imageView frame] is 0,0,0,0 for some reason. Blame @ ios.
    _annotationView = [[AnnotationUIView alloc]initWithFrame:CGRectMake(144, 0, 880, 660)];
    [_annotationView setMarkerColor:[UIColor redColor]];
    [[self view]addSubview:_annotationView];
    [[self view]bringSubviewToFront:_annotationView];
}

-(void)setRed{
    [_annotationView setMarkerColor:[UIColor redColor]];
}

-(void)setGreen{
    [_annotationView setMarkerColor:[UIColor greenColor]];
}

-(void)setBlue{
    [_annotationView setMarkerColor:[UIColor blueColor]];
}

-(void)doClear{
    [_annotationView clear];
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
    [_channel addImagePostWithContent:[_textContent text] image:[self mergeAnnotation] withCompletion:^(ChanImagePost *imagePost, NSError *error){
        [me dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clear:(id)sender {
    [self doClear];
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


@end
