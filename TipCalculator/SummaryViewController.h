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
#import "GuestCheckView.h"

@class Check;

typedef enum { SummaryViewControllerPickerSplit, SummaryViewControllerPickerPercent } SummaryViewControllerPickerType;

@interface SummaryViewController : UIViewController
<AdjustmentsViewControllerDelegate, SettingsViewControllerDelegate, RLNumberPadDelegate, UIPickerViewDelegate>
{
    Check *check_;
    RLNumberPad *numberPad_;
    RLNumberPadDigits *numberPadDigits_;
    GuestCheckView *guestCheckView_;
    UIButton *splitsButton_;
    UIButton *settingsButton_;
	UIButton *fullVersionButton_;
}

@property (nonatomic, retain) InputDisplayView *splitInputView;
@property (nonatomic, retain) InputDisplayView *tipInputView;
@property (nonatomic, retain) InputDisplayView *billAmountInputView;

@property (nonatomic, retain) UIPickerView *pickerView;

@property (nonatomic, assign) NSArray *currentPickerDataSource;
@property (nonatomic, assign) SummaryViewControllerPickerType pickerType;

@end
