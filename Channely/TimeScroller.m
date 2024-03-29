//
//  TimeScroller.m
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.
/*
 Copyright (c) 2011 Andrew Carter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "TimeScroller.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeScroller()

@property (nonatomic, copy) NSDateFormatter *timeDateFormatter;
@property (nonatomic, copy) NSDateFormatter *dayOfWeekDateFormatter;
@property (nonatomic, copy) NSDateFormatter *monthDayDateFormatter;
@property (nonatomic, copy) NSDateFormatter *monthDayYearDateFormatter;

@end


@implementation TimeScroller

- (id)initWithDelegate:(id<TimeScrollerDelegate>)delegate
{
    UIImage *background = [[UIImage imageNamed:@"TimeScroller.bundle/timescroll_pointer"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 35.0f, 0.0f, 10.0f)];
    
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, background.size.height)];
    if (self)
    {
        self.calendar = [NSCalendar currentCalendar];
        
        self.frame = CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(self.frame));
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeTranslation(10.0f, 0.0f);
        
        _backgroundView = [[UIImageView alloc] initWithImage:background];
        _backgroundView.frame = CGRectMake(CGRectGetWidth(self.frame) - 80.0f, 0.0f, 80.0f, CGRectGetHeight(self.frame));
        [self addSubview:_backgroundView];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 4.0f, 50.0f, 20.0f)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.shadowColor = [UIColor blackColor];
        _timeLabel.shadowOffset = CGSizeMake(-0.5f, -0.5f);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9.0f];
        _timeLabel.autoresizingMask = UIViewAutoresizingNone;
        [_backgroundView addSubview:_timeLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 9.0f, 100.0f, 20.0f)];
        _dateLabel.textColor = [UIColor colorWithRed:179.0f green:179.0f blue:179.0f alpha:0.60f];
        _dateLabel.shadowColor = [UIColor blackColor];
        _dateLabel.shadowOffset = CGSizeMake(-0.5f, -0.5f);
        _dateLabel.text = @"6:00 PM";
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9.0f];
        _dateLabel.alpha = 0.0f;
        [_backgroundView addSubview:_dateLabel];
        
        _delegate = delegate;
    }
    return self;
}

- (void)createFormatters
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.calendar.timeZone];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.timeDateFormatter = dateFormatter;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.calendar.timeZone];
    dateFormatter.dateFormat = @"cccc";
    self.dayOfWeekDateFormatter = dateFormatter;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.calendar.timeZone];
    dateFormatter.dateFormat = @"MMMM d";
    self.monthDayDateFormatter = dateFormatter;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:self.calendar];
    [dateFormatter setTimeZone:self.calendar.timeZone];
    dateFormatter.dateFormat = @"MMMM d, yyyy";
    self.monthDayYearDateFormatter = dateFormatter;
}


- (void)setCalendar:(NSCalendar *)cal
{
    _calendar = cal;
    
    [self createFormatters];
}


- (void)captureTableViewAndScrollBar
{
    _collectionView = [self.delegate collectionViewForTimeScroller:self];
    
    self.frame = CGRectMake(CGRectGetWidth(self.frame) - 10.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    for (id subview in [_collectionView subviews])
    {
        // Look for the scrollbar
        if ([subview isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)subview;
            
            if (imageView.frame.size.width == 7.0f)
            {
                imageView.clipsToBounds = NO;
                [imageView addSubview:self];
                _scrollBar = imageView;
                _saved_tableview_size = _collectionView.frame.size;
            }
        }
    }
}

- (void)updateDisplayWithCell:(UICollectionViewCell *)cell
{
    NSDate *date = [self.delegate dateForCell:cell];
    
    if (!date || [date isEqualToDate:_lastDate])
    {
        return;
    }
    if (!_lastDate) {
        _lastDate=[NSDate date];
    }
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateComponents = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *todayComponents = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
//    NSDateComponents *lastDateComponents = [self.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:_lastDate];
    
    _timeLabel.text = [self.timeDateFormatter stringFromDate:date];
    
    _lastDate = date;
    
    CGRect backgroundFrame;
    CGRect timeLabelFrame;
    CGRect dateLabelFrame = _dateLabel.frame;
    NSString *dateLabelString;
    NSString *timeLabelString = _timeLabel.text;
    CGFloat dateLabelAlpha;
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day)
    {
        dateLabelString = @"";
        
        backgroundFrame = CGRectMake(CGRectGetWidth(self.frame) - 80.0f, 0.0f, 80.0f, CGRectGetHeight(self.frame));
        timeLabelFrame = CGRectMake(30.0f, 4.0f, 100.0f, 20.0f);
        dateLabelAlpha = 0.0f;
    }
    else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1))
    {
        timeLabelFrame = CGRectMake(30.0f, 4.0f, 100.0f, 10.0f);
        
        dateLabelString = @"Yesterday";
        dateLabelAlpha = 1.0f;
        backgroundFrame = CGRectMake(CGRectGetWidth(self.frame) - 85.0f, 0.0f, 85.0f, CGRectGetHeight(self.frame));
    }
    else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear))
    {
        timeLabelFrame = CGRectMake(30.0f, 4.0f, 100.0f, 10.0f);
        dateLabelString = [self.dayOfWeekDateFormatter stringFromDate:date];
        dateLabelAlpha = 1.0f;
        
        CGFloat width = 0.0f;
        if ([dateLabelString sizeWithFont:_dateLabel.font].width < 50)
        {
            width = 85.0f;
        }
        else
        {
            width = 95.0f;
        }
        
        backgroundFrame = CGRectMake(CGRectGetWidth(self.frame) - width, 0.0f, width, CGRectGetHeight(self.frame));
    }
    else if (dateComponents.year == todayComponents.year)
    {
        timeLabelFrame = CGRectMake(30.0f, 4.0f, 100.0f, 10.0f);
        
        dateLabelString = [self.monthDayDateFormatter stringFromDate:date];
        dateLabelAlpha = 1.0f;
        
        CGFloat width = [dateLabelString sizeWithFont:_dateLabel.font].width + 50.0f;
        
        backgroundFrame = CGRectMake(CGRectGetWidth(self.frame) - width, 0.0f, width, CGRectGetHeight(self.frame));
    }
    else
    {
        timeLabelFrame = CGRectMake(30.0f, 4.0f, 100.0f, 10.0f);
        dateLabelString = [self.monthDayYearDateFormatter stringFromDate:date];
        dateLabelAlpha = 1.0f;
        
        CGFloat width = [dateLabelString sizeWithFont:_dateLabel.font].width + 50.0f;
        
        backgroundFrame = CGRectMake(CGRectGetWidth(self.frame) - width, 0.0f, width, CGRectGetHeight(self.frame));
    }
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        _timeLabel.frame = timeLabelFrame;
        _dateLabel.frame = dateLabelFrame;
        _dateLabel.alpha = dateLabelAlpha;
        _timeLabel.text = timeLabelString;
        _dateLabel.text = dateLabelString;
        _backgroundView.frame = backgroundFrame;
        
    } completion:nil];
}

- (void)scrollViewDidScroll:(UICollectionViewCell*) cell
{
    if (!_collectionView || !_scrollBar)
    {
        [self captureTableViewAndScrollBar];
    }
    
    [self checkChanges];
    
    if (!_scrollBar)
    {
        return;
    }
    
    CGRect selfFrame = self.frame;
    CGRect scrollBarFrame = _scrollBar.frame;
    
    self.frame = CGRectMake(CGRectGetWidth(selfFrame) * -1.0f,
                            (CGRectGetHeight(scrollBarFrame) / 2.0f) - (CGRectGetHeight(selfFrame) / 2.0f),
                            CGRectGetWidth(selfFrame),
                            CGRectGetHeight(_backgroundView.frame));
    
    CGPoint point = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    point = [_scrollBar convertPoint:point toView:_collectionView];
    
    if (cell) {
        [self updateDisplayWithCell:cell];
        if (![self alpha])
        {
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setAlpha:1.0f];
            } completion:nil];
        }
    }
    else
    {
        if ([self alpha])
        {
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setAlpha:0.0f];
            } completion:nil];
        }
    }
}

- (void)scrollViewDidEndDecelerating
{
    if (!_scrollBar)
    {
        return;
    }
    
    CGRect newFrame = [_scrollBar convertRect:self.frame toView:_collectionView.superview];
    self.frame = newFrame;
    [_collectionView.superview addSubview:self];
    
    [UIView animateWithDuration:0.3f delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeTranslation(10.0f, 0.0f);
        
    } completion:nil];
}


- (void)scrollViewWillBeginDragging
{
    if (!_collectionView || !_scrollBar)
    {
        [self captureTableViewAndScrollBar];
    }
    
    if (!_scrollBar)
    {
        return;
    }
    
    CGRect selfFrame = self.frame;
    CGRect scrollBarFrame = _scrollBar.frame;
    
    
    self.frame = CGRectIntegral(CGRectMake(CGRectGetWidth(selfFrame) * -1.0f,
                                           (CGRectGetHeight(scrollBarFrame) / 2.0f) - (CGRectGetHeight(selfFrame) / 2.0f),
                                           CGRectGetWidth(selfFrame),
                                           CGRectGetHeight(selfFrame)));
    
    [_scrollBar addSubview:self];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState  animations:^{
        
        self.alpha = 1.0f;
        self.transform = CGAffineTransformIdentity;
        
    } completion:nil];
    
}


- (void)invalidate
{
    _collectionView = nil;
    _scrollBar = nil;
    [self removeFromSuperview];
}


- (void)checkChanges
{
    if (!_collectionView ||
        _saved_tableview_size.height != _collectionView.frame.size.height ||
        _saved_tableview_size.width != _collectionView.frame.size.width)
    {
        [self invalidate];
    }
}

@end
