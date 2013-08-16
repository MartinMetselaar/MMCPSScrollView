//
//  MMCPSScrollView.m
//  MMCPSScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import "MMCPSScrollView.h"

@implementation MMCPSScrollView

@synthesize type = _type;

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame andType:MMCPSScrollVertical];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andType:(MMCPSScrollType) type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _segmentSize = [self CGRectSize:frame];
        _pageSize = 1;
        _type = type;
        _scrollingTime = 0.35f;
        
        _bottomComponent = CGRectZero;
        _endScrollingPoint = CGPointZero;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - ScrollView Position Helpers
// These functions are for getting the right value for the calculations to make horizontal and vertical scrolling possible

- (CGFloat) CGPoint:(CGPoint) point {
    if (_type == MMCPSScrollVertical)
        return point.y;
    else
        return point.x;
}

- (CGFloat) contentScrollOffset:(UIScrollView *) scrollView {
    if (_type == MMCPSScrollVertical)
        return scrollView.contentOffset.y;
    else
        return scrollView.contentOffset.x;
}

- (CGFloat) contentScrollSize:(UIScrollView *) scrollView {
    if (_type == MMCPSScrollVertical)
        return scrollView.contentSize.height;
    else
        return scrollView.contentSize.width;
}

- (CGFloat) contentSize:(CGSize) size {
    if (_type == MMCPSScrollVertical)
        return size.height;
    else
        return size.width;
}

- (CGFloat) contentSizeReversed:(CGSize) size {
    if (_type == MMCPSScrollVertical)
        return size.width;
    else
        return size.height;
}

- (CGFloat) frameSize:(UIView *) view {
    return [self CGRectSize:view.frame];
}

- (CGFloat) frameOrigin:(UIView *) view {
    return [self CGRectOrigin:view.frame];
}

- (CGFloat) CGRectOrigin:(CGRect) rect {
    if (_type == MMCPSScrollVertical)
        return rect.origin.y;
    else
        return rect.origin.x;
}

- (CGFloat) CGRectSize:(CGRect) rect {
    if (_type == MMCPSScrollVertical)
        return rect.size.height;
    else
        return rect.size.width;
}

- (CGSize) setCGSize:(CGSize) size withValue:(CGFloat) value {
    if (_type == MMCPSScrollVertical)
        size.height = value;
    else
        size.width = value;
    
    return size;
}

- (CGSize) CGSizeMake:(CGFloat) value1 and:(CGFloat) value2 {
    if (_type == MMCPSScrollVertical)
        return CGSizeMake(value1, value2);
    else
        return CGSizeMake(value2, value1);
}

#pragma mark - Custom ScrollView Helpers

- (BOOL) isScrollViewBouncing:(UIScrollView *) scrollView {
    if ([self contentScrollOffset:scrollView] < 0)
        return YES;
    
    if ([self contentScrollOffset:scrollView] > ([self contentScrollSize:scrollView] - [self frameSize:scrollView]))
        return YES;
    
    return NO;
}

#pragma mark - Scroll to pages

- (void) scrollToPage:(NSInteger) index {
    [self scrollToPage:index withHeight:_segmentSize];
}

- (void) scrollToPage:(NSInteger) index withHeight:(NSInteger) height {
    [self scrollToPage:index withHeight:_segmentSize andSize:_pageSize];
}

- (void) scrollToPage:(NSInteger) index withHeight:(NSInteger) height andSize:(NSInteger) size {
    _currentPage = index + 1;
    // height is the height/width for one segment
    // index is the index of the page
    // size is the number of segments that present one page
    int value = height * index * size;
    
    // check if the page where the user wants so scroll to is in the contentSize of the ScrollView
    if (!(value + [self frameSize:self] < [self contentScrollSize:self])) {
        value = [self contentScrollSize:self] - [self frameSize:self];
    }
    
    [self setContentScrollOffset:value];

    if ([_MMCPSDelegate respondsToSelector:@selector(scrollView:willScrollToPage:)])
        [_MMCPSDelegate scrollView:self willScrollToPage:_currentPage];
    
}

- (void)setContentScrollOffset:(CGFloat) value {
    
    CGPoint contentOffset = CGPointZero;
    if (_type == MMCPSScrollVertical)
        contentOffset = CGPointMake(0, value);
    else
        contentOffset = CGPointMake(value, 0);
    
    [UIView animateWithDuration:_scrollingTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{ [self setContentOffset:contentOffset animated:NO]; }
                     completion:^(BOOL finished){
                         if (finished) {
                             if ([_MMCPSDelegate respondsToSelector:@selector(scrollView:didScrollToPage:)])
                                 [_MMCPSDelegate scrollView:self didScrollToPage:_currentPage];
                         }
                     }];

}

// Scroll forward multiple pages
- (void) scrollPagesForward:(NSInteger) value {
    for (int i = 0; i < value; i++) {
        _pageToScrollToo++;
    }
    
    [self scrollToPage:_pageToScrollToo];
}

// Scroll back multiple pages 
- (void) scrollPagesBack:(NSInteger) value {
    value++;
    for (int i = 0; i < value; i++) {
        _pageToScrollToo--;
    }
    
    [self scrollToPage:_pageToScrollToo];
}

// Scroll to next page
- (void) scrollToNextPage {
    _pageToScrollToo++;
    [self scrollToPage:_pageToScrollToo];
}

// Scroll to previous page
- (void) scrollToPreviousPage {
    if (!_pageToScrollToo <= 0) {
        _pageToScrollToo--;
    } else
        _pageToScrollToo = 0;
    
    [self scrollToPage:_pageToScrollToo];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Keep track when started dragging
    _startDraggingPoint = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {    
    // Check if the ScrollView is within his bounds
    if ([self isScrollViewBouncing:scrollView])
        return;
    
    // Check is any scrolling is needed.
    if ((int) [self contentScrollOffset:scrollView] % (_segmentSize * _pageSize ) != 0) {
        // If the user is not dragging the ScrollView anymore.
        if (!scrollView.isDragging) {
            
            int startPoint = [self CGPoint:_startDraggingPoint];
            float lengthScrolled = [self contentScrollOffset:scrollView] - startPoint;
            
            float numberOfSegments;
            if (lengthScrolled < 0.0f)
                numberOfSegments = floor(lengthScrolled / _segmentSize);
            else
                numberOfSegments = ceil(lengthScrolled / _segmentSize);
            
            int pagesToScroll;
            if (numberOfSegments < 0.0f)
                pagesToScroll = floor(numberOfSegments / _pageSize);
            else
                pagesToScroll = ceil(numberOfSegments / _pageSize);
                        
            if (pagesToScroll < 0) {
                [self scrollPagesBack:abs(pagesToScroll + 1)];
            }else
                [self scrollPagesForward:pagesToScroll];
            
            return;

        }
    }
    
    // Content Offset where the user did end dragging
    _endScrollingPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // Check if the scrollview is not bouncing.
    if ([self isScrollViewBouncing:scrollView])
        return;
    
    // If the _endScrollingPoint has been set then the user has been dragging the ScrollView.
    // So then we can determite what to do.
    if (!CGPointEqualToPoint(_endScrollingPoint, CGPointZero)) {
        
        int startPoint = [self CGPoint:_endScrollingPoint];
        _endScrollingPoint = CGPointZero;
        
        if (startPoint < [self contentScrollOffset:scrollView]) {
            [self scrollToNextPage];
        } else {
            [self scrollToPreviousPage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // When the scrolling is done decelerating then reset the _endScrollingPoint
    _endScrollingPoint = CGPointZero;
}

#pragma mark - UIView

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    
    int currentLowestPoint = [self CGRectOrigin:_bottomComponent] + [self CGRectSize:_bottomComponent];
    int viewLowestPoint = [self frameOrigin:view] + [self frameSize:view];
    
    if (currentLowestPoint < viewLowestPoint) {
        // New lowest point
        _bottomComponent = view.frame;
        
        CGSize contentSize = [self CGSizeMake:[self contentSizeReversed:self.contentSize]
                                          and:[self frameOrigin:view] + [self frameSize:view]];
        
        // Check if the contentSize does not corresponds with the pages
        if (!_enableFitScreen && !((int)contentSize.height % (_pageSize * _segmentSize) == 0)) {

            // Calculate how much 'white space' is needed.
            int currentContentSize = [self contentSize:contentSize];
            int sizeOnePage = (_pageSize * _segmentSize);
            int canSomebodyPleaseRenameThisValueIfHeOrSheFindsOutHowToCallIt = ((int)[self contentSize:contentSize] % (_pageSize * _segmentSize));
            
            CGFloat value = sizeOnePage - canSomebodyPleaseRenameThisValueIfHeOrSheFindsOutHowToCallIt + currentContentSize;
            contentSize = [self setCGSize:contentSize withValue:value];
        }
        
        [self setContentSize:contentSize];
    }
}

@end
