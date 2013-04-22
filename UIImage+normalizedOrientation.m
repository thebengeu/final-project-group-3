//
//  UIImage+normalizedOrientation.m
//  Channely
//
//  Created by Beng on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UIImage+normalizedOrientation.h"

@implementation UIImage (normalizeOrientation)

// Ref: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
- (UIImage *)normalizedImage
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect) {0, 0, self.size }];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
