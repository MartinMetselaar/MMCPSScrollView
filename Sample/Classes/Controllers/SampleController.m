//
//  SampleController.m
//  MMCPSScrollView
//
//  Created by Martin on 02-04-13.
//  Copyright (c) 2013 Martin Metselaar. All rights reserved.
//

#import "SampleController.h"
#import "RandomColorView.h"

@interface SampleController ()

- (void) buildView;

@end

@implementation SampleController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) buildView {
    
    [self calculateCustomPageHeight];
    
    scrollType = MMCPSScrollVertical;
    
    _scrollView = [[MMCPSScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setType:scrollType];
    [_scrollView setPageHeight:customPageHeight];
    [_scrollView setPageSize:2];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollView];
    
    if (scrollType == MMCPSScrollVertical)
        [self fillScrollViewVertical];
    else if (scrollType == MMCPSScrollHorizontal)
        [self fillScrollViewHorizontal];
    
    _initialized = YES;
}

- (void) calculateCustomPageHeight {
    if (scrollType == MMCPSScrollVertical)
        customPageHeight = self.view.bounds.size.height / 2;
    else if (scrollType == MMCPSScrollHorizontal)
        customPageHeight = self.view.bounds.size.width / 2;
    
    
    customPageHeight = 310;
}

- (void) fillScrollViewVertical {
    NSInteger numberOfComponents = 15;
    
    RandomColorView* view = nil;
    CGRect frame = self.view.bounds;
    frame.size.height = customPageHeight;
    for (int i = 0; i < numberOfComponents; i++) {
        view = [[RandomColorView alloc] init];
        frame.origin.y = i * customPageHeight;
        [view setFrame:frame];
        [_scrollView addSubview:view];
    }
}

- (void) fillScrollViewHorizontal {
    NSInteger numberOfComponents = 15;
    
    RandomColorView* view = nil;
    CGRect frame = self.view.bounds;
    frame.size.width = customPageHeight;
    for (int i = 0; i < numberOfComponents; i++) {
        view = [[RandomColorView alloc] init];
        frame.origin.x = i * customPageHeight;
        [view setFrame:frame];
        [_scrollView addSubview:view];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_initialized)
        [self buildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // TODO : Proper rotation
    
    for (UIView* v in _scrollView.subviews) {
        [v removeFromSuperview];
        [v release];
        v = nil;
    }
    
    [_scrollView setPageHeight:customPageHeight];
    
    if (_scrollView.type == MMCPSScrollHorizontal) {
        [self fillScrollViewHorizontal];
    } else {
        [self fillScrollViewVertical];
    }
}

- (void)dealloc {
    if (_scrollView) { [_scrollView release]; _scrollView = nil; }
    [super dealloc];
}

@end
