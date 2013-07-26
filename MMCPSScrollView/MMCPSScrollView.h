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

@interface MMCPSScrollView : UIScrollView <UIScrollViewDelegate> {
    MMCPSScrollType _type;
    
    CGPoint _endScrollingPoint;
    CGPoint _startDraggingPoint;
    NSInteger _pageToScrollToo;

    // The height of one segment
    NSInteger _pageHeight;
    // The number of segments that represent one page
    NSInteger _pageSize;
    
    CGRect _bottomComponent;
}

@property (nonatomic) NSInteger segmentSize;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) MMCPSScrollType type;

- (id)initWithFrame:(CGRect)frame andType:(MMCPSScrollType) type;

@end
