//
//  ContentController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentController.h"
#import "SummaryViewController.h"
#import "AdjustmentsViewController.h"

static NSUInteger kNumberOfPages = 2;

@interface ContentController (PrivateMethods)

- (void)loadScrollViewWithPage:(NSInteger)page;

@end

@implementation ContentController

@synthesize scrollView = scrollView_;
@synthesize pageControl = pageControl_;
@synthesize viewControllers = viewControllers_;

- (void)awakeFromNib
{
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    scrollView_.pagingEnabled = YES;
    scrollView_.contentSize = CGSizeMake(scrollView_.frame.size.width * kNumberOfPages,
                                         scrollView_.frame.size.height);
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.scrollsToTop = NO;
    
    pageControl_.numberOfPages = kNumberOfPages;
    pageControl_.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)dealloc
{
    [scrollView_ release];
    [pageControl_ release];
    [viewControllers_ release];
    [super dealloc];
}

#pragma mark - Public Methods

- (UIView *)view
{
    return self.scrollView;
}

- (IBAction)changePage:(id)sender
{	
    NSInteger page = pageControl_.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView_.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView_ scrollRectToVisible:frame animated:YES];
    
    pageControlUsed_ = YES;
}

#pragma mark - Private Methods

- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    UIViewController *controller = [viewControllers_ objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        if (page == 0) {
            controller = (SummaryViewController *)[[SummaryViewController alloc] init];
        } else {
            controller = (AdjustmentsViewController *)[[AdjustmentsViewController alloc] init];
        }
        [viewControllers_ replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the content view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView_.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView_ addSubview:controller.view];
    }
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed_)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView_.frame.size.width;
    NSInteger page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl_.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed_ = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed_ = NO;
}


@end
