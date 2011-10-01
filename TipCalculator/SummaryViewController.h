//
//  SummaryViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Check;

typedef enum { SummaryViewControllerPickerSplit, SummaryViewControllerPickerPercent } SummaryViewControllerPickerType;

@interface SummaryViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *summaryTable;
@property (nonatomic, retain) NSArray *summaryDataSource;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *splitDataSource;
@property (nonatomic, retain) NSArray *tipPercentDataSource;
@property (nonatomic, assign) NSArray *currentPickerDataSource;
@property (nonatomic, assign) SummaryViewControllerPickerType pickerType;

@property (nonatomic, retain) UITextField *billTotalTextField;

@property (nonatomic, retain) Check *currentCheck;

@property (nonatomic, assign) UIViewController *contentViewController;

@end
