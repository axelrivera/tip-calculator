//
//  AdjustmentsViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Check.h"

@protocol AdjustmentsViewControllerDelegate;

@interface AdjustmentsViewController : UIViewController
{
    Check *check_;
}

@property (nonatomic, assign) id <AdjustmentsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *adjusmentsTable;
@property (nonatomic, retain) IBOutlet UITextField *adjustmentTextField;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;

- (IBAction)backAction:(id)sender;
- (IBAction)resetAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end

@protocol AdjustmentsViewControllerDelegate

- (void)adjustmentsViewControllerDidFinish:(AdjustmentsViewController *)controller;

@end


