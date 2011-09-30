//
//  ContentViewController.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface ContentViewController : UIViewController <UIScrollViewDelegate, SettingsViewControllerDelegate>
{
    BOOL pageControlUsed_;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *selectedViewController;

- (IBAction)changePageAction:(id)sender;
- (IBAction)infoButtonAction:(id)sender;

@end
