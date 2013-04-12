//
//  AnnotationUIViewController.m
//  AnnotationDemo
//
//  Created by k on 5/4/13.
//  Copyright (c) 2013 k. All rights reserved.
//

#import "AnnotationUIView.h"
#import <QuartzCore/QuartzCore.h>

@interface AnnotationUIView ()

@property NSMutableArray *currentStrokePoints;

@property NSMutableArray *strokesPoints;
@property NSMutableArray *strokeSizes;
@property NSMutableArray *strokeColors;

@end


@implementation AnnotationUIView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        //[self setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
        [self setUserInteractionEnabled:YES];
        _currentStrokePoints = [[NSMutableArray alloc]init];
        _strokesPoints = [[NSMutableArray alloc]init];
        _strokeSizes = [[NSMutableArray alloc]init];
        _strokeColors = [[NSMutableArray alloc]init];
        
        UIPanGestureRecognizer *draw = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(draw:)];
        [draw setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:draw];
        
        _markerColor = [UIColor redColor];
        _markerSize = (CGFloat)3.0;
        
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setImage:blank];
        [self setContentMode:UIViewContentModeScaleAspectFit];
    }
    return self;
}

-(void)clear{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setImage:blank];

}

-(float)pointToDist:(CGPoint) p{
    return sqrt(p.x * p.x + p.y * p.y);
}

-(float)distanceBetweenTwoPoints:(CGPoint)first :(CGPoint)second{
    return sqrt(pow(first.x-second.x,2.0) + pow(first.y-second.y, 2.0));
}

- (void)draw:(UIGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _currentStrokePoints = [[NSMutableArray alloc]init];
        
        [self addPointAndDraw:point];
        [self addPointAndDraw:point];
        [self addPointAndDraw:point];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        //! skip points that are too close
        float eps = 1.5f;
        if ([_currentStrokePoints count] > 0) {
            float length = [self distanceBetweenTwoPoints:point :[(NSValue*)[_currentStrokePoints lastObject] CGPointValue]];
            if (length < eps)
                return;
        }
        [self addPointAndDraw:point];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self addPointAndDraw:point];
        [[self strokesPoints]addObject:_currentStrokePoints];
        [[self strokeSizes]addObject:[NSNumber numberWithFloat: _markerSize]];
        [[self strokeColors]addObject: _markerColor];
    }
}
         
-(void)addPointAndDraw:(CGPoint)point{
    [_currentStrokePoints addObject:[NSValue valueWithCGPoint:point]];
    [self setupDrawContext];
    [self drawStrokeSection:[_currentStrokePoints count]-1];
    [self doneDrawContext];
}

-(void)drawStrokeSection:(int) i{
    if (i < 2)
        return;
    
    CGPoint previousPoint = CGPointMake(0, 0);
    
    CGPoint prev2 = [(NSValue*)[_currentStrokePoints objectAtIndex:i - 2] CGPointValue];
    CGPoint prev1 = [(NSValue*)[_currentStrokePoints objectAtIndex:i - 1] CGPointValue];
    CGPoint cur = [(NSValue*)[_currentStrokePoints objectAtIndex:i] CGPointValue];
    
    CGPoint midPoint1 = CGPointMake((prev1.x+prev2.x)/2.0, (prev1.y+prev2.y)/2.0);
    CGPoint midPoint2 = CGPointMake((cur.x+prev1.x)/2.0, (cur.y+prev1.y)/2.0);
    int segmentDistance = 2;
    float distance = [self distanceBetweenTwoPoints: midPoint1 :midPoint2];
    int numberOfSegments = MIN(32, MAX(floorf(distance / segmentDistance), 8));
    
    float t = 0.0f;
    float step = 1.0f / (float)numberOfSegments;
    for (NSUInteger j = 0; j < numberOfSegments; j++) {
        float mid2X = midPoint2.x*t*t, mid2Y = midPoint2.y*t*t;
        float mid1X = midPoint1.x * pow(1-t,2.0), mid1Y = midPoint1.y * pow(1-t,2.0);
        float prev1X = prev1.x * 2.0 * (1-t) * t, prev1Y = prev1.y * 2.0 * (1-t) * t;
        CGPoint newPoint = CGPointMake(mid2X+mid1X+prev1X, mid2Y+mid1Y+prev1Y);
        
        if (j > 0)
            [self drawCanvasLineSegmentFromPoint:previousPoint toPoint:newPoint withSize:_markerSize];
        
        t += step;
        previousPoint = newPoint;
    }
    
    [self drawCanvasLineSegmentFromPoint:previousPoint toPoint:midPoint2 withSize:_markerSize];
}

-(void)setupDrawContext{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [_markerColor CGColor]);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

}

-(void)drawCanvasLineSegmentFromPoint:(CGPoint)previousPoint toPoint:(CGPoint)point withSize:(float)size{
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
}

-(void)doneDrawContext{
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(UIImage*)screenshot{
    CGRect rect = [self bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

@end
