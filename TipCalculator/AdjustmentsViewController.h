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

@interface AdjustmentsViewController : UIViewController <RLNumberPadDelegate, UIActionSheetDelegate>
{
    Check *check_;
    RLNumberPad *numberPad_;
    RLNumberPadDigits *numberPadDigits_;
    UIButton *currentDeleteButton_;
}

@property (nonatomic, assign) id <AdjustmentsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *adjusmentsTable;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UIButton *resetButton;
@property (nonatomic, retain) UIButton *questionButton;
@property (nonatomic, retain) InputDisplayView *adjustmentsInputView;
@property (nonatomic, retain) NSDecimalNumber *currentAdjustment;

@end

@protocol AdjustmentsViewControllerDelegate

- (void)adjustmentsViewControllerDidFinish:(AdjustmentsViewController *)controller;

@end


