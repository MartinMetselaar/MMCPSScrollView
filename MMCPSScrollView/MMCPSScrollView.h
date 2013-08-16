//
//  MMCPSScrollView.h
//  MMCPSScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MMCPSScrollHorizontal,
    MMCPSScrollVertical
} MMCPSScrollType;

@class MMCPSScrollView;

@protocol MMCPSScrollViewDelegate <NSObject>

- (void) scrollView:(MMCPSScrollView *) scrollView willScrollToPage:(NSUInteger) pageIndex;
- (void) scrollView:(MMCPSScrollView *) scrollView didScrollToPage:(NSUInteger) pageIndex;

@end

@interface MMCPSScrollView : UIScrollView <UIScrollViewDelegate> {
    MMCPSScrollType _type;
    
    CGPoint _endScrollingPoint;
    CGPoint _startDraggingPoint;
    NSInteger _pageToScrollToo;
    
    CGRect _bottomComponent;
}

// The height of one segment
@property (nonatomic) NSInteger segmentSize;
// The number of segments that represent one page
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) MMCPSScrollType type;

// Set to true if you want it to fit the screen.
// Set to false if you want to have white space.
@property (nonatomic, assign) BOOL enableFitScreen;

// Time it takes to scroll to next page
@property (nonatomic) CGFloat scrollingTime;

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic, retain) id<MMCPSScrollViewDelegate> MMCPSDelegate;

- (id)initWithFrame:(CGRect)frame andType:(MMCPSScrollType) type;

@end
