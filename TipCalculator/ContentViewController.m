//
//  ContentViewController.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"
#import "SummaryViewController.h"
#import "AdjustmentsViewController.h"

static NSUInteger kNumberOfPages = 2;
static NSUInteger kSummaryPageIndex = 0;
static NSUInteger kAdjustmentsPageIndex = 1;

@interface ContentViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(NSInteger)page;

@end

@implementation ContentViewController

@synthesize scrollView = scrollView_;
@synthesize pageControl = pageControl_;
@synthesize infoButton = infoButton_;
@synthesize viewControllers = viewControllers_;
@synthesize selectedViewController = selectedViewController_;

- (id)init
{
    self = [super initWithNibName:@"ContentViewController" bundle:nil];
    if (self) {
        SummaryViewController *summaryViewController = [[SummaryViewController alloc] init];
        summaryViewController.contentViewController = self;
        AdjustmentsViewController *adjustmentsViewController = [[AdjustmentsViewController alloc] init];
        adjustmentsViewController.contentViewController = self;
        
        viewControllers_ = [[NSArray alloc] initWithObjects:
                           summaryViewController,
                           adjustmentsViewController,
                           nil];
        
        self.selectedViewController = summaryViewController;
        
        [summaryViewController release];
        [adjustmentsViewController release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [scrollView_ release];
    [pageControl_ release];
    [infoButton_ release];
    [viewControllers_ release];
    [selectedViewController_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
    
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
    [self loadScrollViewWithPage:kSummaryPageIndex];
    [self loadScrollViewWithPage:kAdjustmentsPageIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    self.infoButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.selectedViewController viewDidDisappear:animated];
}

#pragma mark - Custom Methods

- (IBAction)changePageAction:(id)sender
{	
    NSInteger page = pageControl_.currentPage;
    
    UIViewController *currentViewController = selectedViewController_;
    self.selectedViewController = [viewControllers_ objectAtIndex:page];
    
    // Current view will hide
    [currentViewController viewWillDisappear:YES];
    [selectedViewController_ viewWillAppear:YES];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView_.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView_ scrollRectToVisible:frame animated:YES];
    
    // New view Shown
    [currentViewController viewDidDisappear:YES];
    [selectedViewController_ viewDidAppear:YES];
    
    pageControlUsed_ = YES;
}

- (IBAction)infoButtonAction:(id)sender
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[settingsViewController release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (page < 0 || page >= kNumberOfPages)
        return;
    
    UIViewController *controller = [viewControllers_ objectAtIndex:page];
    
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
    
    if (page != pageControl_.currentPage) {
        UIViewController *currentViewController = selectedViewController_;
        self.selectedViewController = [viewControllers_ objectAtIndex:page];
        
        // Current view will hide
        [currentViewController viewWillDisappear:YES];
        [selectedViewController_ viewWillAppear:YES];
        
        pageControl_.currentPage = page;
        
        // New view Shown
        [currentViewController viewDidDisappear:YES];
        [selectedViewController_ viewDidAppear:YES];
    }
    
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
