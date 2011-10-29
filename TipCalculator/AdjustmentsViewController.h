//
//  AdjustmentsViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Check.h"
#import "RLNumberPad.h"
#import "RLNumberPadDigits.h"
#import "InputDisplayView.h"

@protocol AdjustmentsViewControllerDelegate;

@interface AdjustmentsViewController : UIViewController <RLNumberPadDelegate>
{
    Check *check_;
    RLNumberPad *numberPad_;
    RLNumberPadDigits *numberPadDigits_;
}

@property (nonatomic, assign) id <AdjustmentsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *adjusmentsTable;
@property (nonatomic, retain) InputDisplayView *adjustmentsInputView;
@property (nonatomic, retain) NSDecimalNumber *currentAdjustment;

- (IBAction)backAction:(id)sender;
- (IBAction)resetAction:(id)sender;

@end

@protocol AdjustmentsViewControllerDelegate

- (void)adjustmentsViewControllerDidFinish:(AdjustmentsViewController *)controller;

@end


