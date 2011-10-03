//
//  SummaryViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckData;
@class Check;
@class RLInputButton;

typedef enum { SummaryViewControllerPickerSplit, SummaryViewControllerPickerPercent } SummaryViewControllerPickerType;

@interface SummaryViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    CheckData *checkData_;
    NSInteger pickerSplitIndex_;
    NSInteger pickerPercentIndex_;
}

@property (nonatomic, retain) IBOutlet UITableView *summaryTable;

@property (nonatomic, retain) NSString *numberOfSplitStr;
@property (nonatomic, retain) NSString *tipPercentageStr;
@property (nonatomic, retain) NSString *amountStr;
@property (nonatomic, retain) NSString *totalTipStr;
@property (nonatomic, retain) NSString *totalToPayStr;
@property (nonatomic, retain) NSString *totalPerPersonStr;

@property (nonatomic, retain) RLInputButton *splitButton;
@property (nonatomic, retain) RLInputButton *tipButton;
@property (nonatomic, retain) RLInputButton *amountButton;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, assign) NSArray *currentPickerDataSource;
@property (nonatomic, assign) SummaryViewControllerPickerType pickerType;

@property (nonatomic, retain) UITextField *billTotalTextField;

@property (nonatomic, assign) UIViewController *contentViewController;

@end
