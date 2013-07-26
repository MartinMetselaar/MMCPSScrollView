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
    
    [self calculateCustomSegmentSize];
    
    scrollType = MMCPSScrollHorizontal;
    
    _scrollView = [[MMCPSScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setType:scrollType];
    [_scrollView setSegmentSize:customSegmentSize];
    [_scrollView setPageSize:2];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setMMCPSDelegate:self];
    [self.view addSubview:_scrollView];
    
    if (scrollType == MMCPSScrollVertical)
        [self fillScrollViewVertical];
    else if (scrollType == MMCPSScrollHorizontal)
        [self fillScrollViewHorizontal];
    
    _initialized = YES;
}

- (void) calculateCustomSegmentSize {
    if (scrollType == MMCPSScrollVertical)
        customSegmentSize = self.view.bounds.size.height / 2;
    else if (scrollType == MMCPSScrollHorizontal)
        customSegmentSize = self.view.bounds.size.width / 2;
    
    customSegmentSize = 310;
}

- (void) fillScrollViewVertical {
    NSInteger numberOfComponents = 15;
    
    RandomColorView* view = nil;
    CGRect frame = self.view.bounds;
    frame.size.height = customSegmentSize;
    for (int i = 0; i < numberOfComponents; i++) {
        view = [[RandomColorView alloc] init];
        frame.origin.y = i * customSegmentSize;
        [view setFrame:frame];
        [_scrollView addSubview:view];
    }
}

- (void) fillScrollViewHorizontal {
    NSInteger numberOfComponents = 15;
    
    RandomColorView* view = nil;
    CGRect frame = self.view.bounds;
    frame.size.width = customSegmentSize;
    for (int i = 0; i < numberOfComponents; i++) {
        view = [[RandomColorView alloc] init];
        frame.origin.x = i * customSegmentSize;
        [view setFrame:frame];
        [_scrollView addSubview:view];
    }
}

#pragma mark - MMCPSScrollViewDelegate 

- (void)scrollView:(MMCPSScrollView *)scrollView didScrollToPage:(NSUInteger)pageIndex {
    NSLog(@"The MMCPSScrollView is now on page %i.", pageIndex);
}

- (void)scrollView:(MMCPSScrollView *)scrollView willScrollToPage:(NSUInteger)pageIndex {
    NSLog(@"The MMCPSScrollView is now going to page %i.", pageIndex);
}

#pragma mark - UIViewController

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
    
    [_scrollView setSegmentSize:customSegmentSize];
    
    if (_scrollView.type == MMCPSScrollHorizontal) {
        [self fillScrollViewHorizontal];
    } else {
        [self fillScrollViewVertical];
    }
}

// alternative for shouldAutorotateToInterfaceOrientation
- (NSUInteger)supportedInterfaceOrientations {
    return [super supportedInterfaceOrientations];
}

// Deprecated since iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)dealloc {
    if (_scrollView) { [_scrollView release]; _scrollView = nil; }
    [super dealloc];
}

@end
