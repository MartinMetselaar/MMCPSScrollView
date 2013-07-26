//
//  SampleController.h
//  MMCPSScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCPSScrollView.h"

@interface SampleController : UIViewController {
	BOOL _initialized;
    
    MMCPSScrollView* _scrollView;
    
    NSInteger customSegmentSize;
    MMCPSScrollType scrollType;
}

@end
