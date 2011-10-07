//
//  AdjustmentsViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckData;

@protocol AdjustmentsViewControllerDelegate;

@interface AdjustmentsViewController : UIViewController
{
    CheckData *checkData_;
}

@property (nonatomic, assign) id <AdjustmentsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *adjusmentsTable;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;

@property (nonatomic, retain) NSArray *adjustmentViews;

- (IBAction)backAction:(id)sender;

@end

@protocol AdjustmentsViewControllerDelegate

- (void)adjustmentsViewControllerDidFinish:(AdjustmentsViewController *)controller;

@end


