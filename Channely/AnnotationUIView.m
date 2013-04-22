//
//  AnnotationUIViewController.m
//  AnnotationDemo
//
//  Created by k on 5/4/13.
//  Copyright (c) 2013 k. All rights reserved.
//

#import "AnnotationUIView.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface AnnotationUIView ()

@property NSMutableArray *currentStrokePoints;

@property NSMutableArray *strokesPoints;
@property NSMutableArray *strokeSizes;
@property NSMutableArray *strokeColors;

@property NSInteger currentStrokeIndex;

@property CGFloat scale;

@end


@implementation AnnotationUIView

@synthesize originalImage = _originalImage;

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

/*
 
 Setup the view controller
 
 */
- (void)setup
{
    [self setUserInteractionEnabled:YES];
    _currentStrokePoints = [[NSMutableArray alloc]init];
    _strokesPoints = [[NSMutableArray alloc]init];
    _strokeSizes = [[NSMutableArray alloc]init];
    _strokeColors = [[NSMutableArray alloc]init];
    
    UIPanGestureRecognizer *draw = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(draw:)];
    [draw setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:draw];
    
    _markerColor = [UIColor redColor];
    _markerSize = kMarkerSize;
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setImage:blank];
    [self setContentMode:UIViewContentModeScaleAspectFit];
    
    _currentStrokeIndex = 0;
}

/*
 
 Adds a line segment between 2 user touch input points
 
 */
- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    self.image = originalImage;
}

- (UIImage *)originalImage
{
    return _originalImage;
}

/*
 
 Reset the image to before any annotations were made
 
 */
- (void)clear
{
    [self setImage:_originalImage];
    [_strokeColors removeAllObjects];
    [_strokeSizes removeAllObjects];
    [_strokesPoints removeAllObjects];
    _currentStrokeIndex = 0;
}

/*
 
 Maths functions for drawing calculations
 
 */
- (float)pointToDist:(CGPoint)p
{
    return sqrt(p.x * p.x + p.y * p.y);
}

- (float)distanceBetweenTwoPoints:(CGPoint)first:(CGPoint)second
{
    return sqrt(pow(first.x - second.x, 2.0) + pow(first.y - second.y, 2.0));
}

/*
 
 Handle user touch gesture for drawing
 
 */
- (void)draw:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _currentStrokePoints = [[NSMutableArray alloc]init];
        
        [self addPointAndDraw:point];
        [self addPointAndDraw:point];
        [self addPointAndDraw:point];
        
        _scale = [self contentScaleFactor];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        //! skip points that are too close
        float eps = 1.5f;
        if ([_currentStrokePoints count] > 0) {
            float length = [self distanceBetweenTwoPoints:point:[(NSValue *)[_currentStrokePoints lastObject] CGPointValue]];
            if (length < eps) return;
        }
        [self addPointAndDraw:point];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self addPointAndDraw:point];
        
        //  Clear stored redos after current index
        while (_currentStrokeIndex < [_strokesPoints count]) {
            [_strokesPoints removeLastObject];
            [_strokeSizes removeLastObject];
            [_strokeColors removeLastObject];
        }
        
        [_strokesPoints addObject:_currentStrokePoints];
        [_strokeSizes addObject:[NSNumber numberWithFloat:_markerSize]];
        [_strokeColors addObject:_markerColor];
        
        _currentStrokeIndex = [_strokesPoints count];
    }
}

/*
 
 Adds a line segment between 2 user touch input points
 
 */
- (void)addPointAndDraw:(CGPoint)point
{
    [_currentStrokePoints addObject:[NSValue valueWithCGPoint:point]];
    [self setupDrawContext:YES];
    [self drawStrokeSection:[_currentStrokePoints count] - 1];
    [self doneDrawContext:YES];
}

/*
 
 Draws a line segment between 2 user touch input points (For Quartz code)
 
 */
- (void)drawStrokeSection:(int)i
{
    if (i < 2) return;
    
    CGPoint previousPoint = CGPointMake(0, 0);
    
    CGPoint prev2 = [(NSValue *)[_currentStrokePoints objectAtIndex:i - 2] CGPointValue];
    CGPoint prev1 = [(NSValue *)[_currentStrokePoints objectAtIndex:i - 1] CGPointValue];
    CGPoint cur = [(NSValue *)[_currentStrokePoints objectAtIndex:i] CGPointValue];
    
    CGPoint midPoint1 = CGPointMake((prev1.x + prev2.x) / 2.0, (prev1.y + prev2.y) / 2.0);
    CGPoint midPoint2 = CGPointMake((cur.x + prev1.x) / 2.0, (cur.y + prev1.y) / 2.0);
    int segmentDistance = 2;
    float distance = [self distanceBetweenTwoPoints:midPoint1:midPoint2];
    int numberOfSegments = MIN(kMarkerMaxSegment, MAX(floorf(distance / segmentDistance), kMarkerMinSegment));
    
    float t = 0.0f;
    float step = 1.0f / (float)numberOfSegments;
    for (NSUInteger j = 0; j < numberOfSegments; j++) {
        float mid2X = midPoint2.x * t * t, mid2Y = midPoint2.y * t * t;
        float mid1X = midPoint1.x * pow(1 - t, 2.0), mid1Y = midPoint1.y * pow(1 - t, 2.0);
        float prev1X = prev1.x * 2.0 * (1 - t) * t, prev1Y = prev1.y * 2.0 * (1 - t) * t;
        CGPoint newPoint = CGPointMake(mid2X + mid1X + prev1X, mid2Y + mid1Y + prev1Y);
        
        if (j > 0) [self drawCanvasLineSegmentFromPoint:previousPoint toPoint:newPoint withSize:_markerSize];
        
        t += step;
        previousPoint = newPoint;
    }
    
    [self drawCanvasLineSegmentFromPoint:previousPoint toPoint:midPoint2 withSize:_markerSize];
}

/*
 
 Setup the draw context by taking the image and putting it as the CGContext
 
 */
- (void)setupDrawContext:(BOOL)newImage
{
    if (newImage) {
        UIGraphicsBeginImageContextWithOptions(self.image.size, YES, [[UIScreen mainScreen] scale]);
        [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    }
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [_markerColor CGColor]);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
}

- (void)drawCanvasLineSegmentFromPoint:(CGPoint)previousPoint toPoint:(CGPoint)point withSize:(float)size
{
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size / _scale);
    CGFloat ratio = MIN(self.frame.size.width / self.image.size.width, self.frame.size.height / self.image.size.height);
    CGFloat offsetX = MAX((self.frame.size.width / ratio - self.image.size.width) / 2.0, 0);
    CGFloat offsetY = MAX((self.frame.size.height / ratio - self.image.size.height) / 2.0, 0);
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x / ratio - offsetX, previousPoint.y / ratio - offsetY);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x / ratio - offsetX, point.y / ratio - offsetY);
}

- (void)doneDrawContext:(BOOL)lastStroke
{
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    if (lastStroke) {
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)undo
{
    //  Ensure that there are moves to undo
    if (_currentStrokeIndex <= 0) return;
    
    //  Reset the image
    [self setImage:_originalImage];
    _currentStrokeIndex--;
    
    //  Redraw the points before
    for (int i = 0; i < _currentStrokeIndex; i++) {
        _currentStrokePoints = [_strokesPoints objectAtIndex:i];
        _markerColor = [_strokeColors objectAtIndex:i];
        _markerSize = [[_strokeSizes objectAtIndex:i] floatValue];
        
        if (i == 0) [self setupDrawContext:YES];
        else [self setupDrawContext:NO];
        
        for (int j = 0; j < [_currentStrokePoints count]; j++) {
            [self drawStrokeSection:j];
        }
        
        if (i == _currentStrokeIndex - 1) [self doneDrawContext:YES];
        else [self doneDrawContext:NO];
    }
}

- (void)redo
{
    //  Redo the next stroke
    if (_currentStrokeIndex >= [_strokeSizes count]) return;
    
    _currentStrokePoints = [_strokesPoints objectAtIndex:_currentStrokeIndex];
    _markerColor = [_strokeColors objectAtIndex:_currentStrokeIndex];
    _markerSize = [[_strokeSizes objectAtIndex:_currentStrokeIndex] floatValue];
    
    [self setupDrawContext:YES];
    
    //  Draw each stroke section
    for (int j = 0; j < [_currentStrokePoints count]; j++) {
        [self drawStrokeSection:j];
    }
    
    [self doneDrawContext:YES];
    
    _currentStrokeIndex++;
}

/*
 
 Determine the scale factor of an image and the imageView
 
 */
- (CGFloat)contentScaleFactor
{
    CGFloat widthScale = self.bounds.size.width / self.image.size.width;
    CGFloat heightScale = self.bounds.size.height / self.image.size.height;
    
    if (self.contentMode == UIViewContentModeScaleToFill) {
        return (widthScale == heightScale) ? widthScale : NAN;
    }
    if (self.contentMode == UIViewContentModeScaleAspectFit) {
        return MIN(widthScale, heightScale);
    }
    if (self.contentMode == UIViewContentModeScaleAspectFill) {
        return MAX(widthScale, heightScale);
    }
    return 1.0;
}

@end
