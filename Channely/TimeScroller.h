//
//  TimeScroller.h
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.
/*
 Copyright (c) 2011 Andrew Carter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Cedric Chin:
 Modifications have been made:
    * To work with a collectionview
    * To take event timings into account. 
*/
#import <UIKit/UIKit.h>

@class TimeScroller;

@protocol TimeScrollerDelegate <NSObject>

@required

- (UICollectionView *)collectionViewForTimeScroller:(TimeScroller *)timeScroller;
- (NSDate *)dateForCell:(UICollectionViewCell *)cell;

@end

@interface TimeScroller : UIImageView {
    
    @protected
    id <TimeScrollerDelegate> __unsafe_unretained _delegate;
    UICollectionView *_collectionView;
    UIImageView *_scrollBar;
    UILabel *_timeLabel;
    UILabel *_dateLabel;
    UIImageView *_backgroundView;
    NSDate *_lastDate;
    CGSize _saved_tableview_size;
    
}

@property (nonatomic, unsafe_unretained) id <TimeScrollerDelegate> delegate;
@property (nonatomic, copy) NSCalendar *calendar;

- (id)initWithDelegate:(id <TimeScrollerDelegate>)delegate;
- (void)scrollViewDidScroll:(UICollectionViewCell*) cell;
- (void)scrollViewDidEndDecelerating;
- (void)scrollViewWillBeginDragging;

@end
