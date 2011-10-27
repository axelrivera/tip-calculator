//
//  SummaryViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdjustmentsViewController.h"
#import "SettingsViewController.h"
#import "RLNumberPad.h"
#import "RLNumberPadDigits.h"
#import "InputDisplayView.h"

@class Check;

typedef enum { SummaryViewControllerPickerSplit, SummaryViewControllerPickerPercent } SummaryViewControllerPickerType;

@interface SummaryViewController : UIViewController
<AdjustmentsViewControllerDelegate, SettingsViewControllerDelegate, RLNumberPadDelegate>
{
    Check *check_;
    RLNumberPad *numberPad_;
    RLNumberPadDigits *numberPadDigits_;
}

@property (nonatomic, retain) InputDisplayView *splitInputView;
@property (nonatomic, retain) InputDisplayView *tipInputView;
@property (nonatomic, retain) InputDisplayView *billAmountInputView;

@property (nonatomic, retain) IBOutlet UIView *checkSummaryView;
@property (nonatomic, retain) IBOutlet UILabel *totalTipLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalToPayLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalPerPersonLabel;

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) NSArray *currentPickerDataSource;
@property (nonatomic, assign) SummaryViewControllerPickerType pickerType;

- (IBAction)showAdjustmentsAction:(id)sender;
- (IBAction)showSettingsAction:(id)sender;

@end
