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
    
    CGRect _bottomComponent;
}

// The height of one segment
@property (nonatomic) NSInteger segmentSize;
// The number of segments that represent one page
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) MMCPSScrollType type;

- (id)initWithFrame:(CGRect)frame andType:(MMCPSScrollType) type;

@end
