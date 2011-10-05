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

@interface SummaryViewController : UIViewController
{
    CheckData *checkData_;
    NSNumberFormatter *formatter_;
}

@property (nonatomic, retain) IBOutlet RLInputButton *splitButton;
@property (nonatomic, retain) IBOutlet RLInputButton *tipButton;
@property (nonatomic, retain) IBOutlet RLInputButton *amountButton;
@property (nonatomic, retain) IBOutlet UILabel *splitLabel;
@property (nonatomic, retain) IBOutlet UILabel *tipPercentageLabel;
@property (nonatomic, retain) IBOutlet UITextField *billAmountTextField;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) NSArray *currentPickerDataSource;
@property (nonatomic, assign) SummaryViewControllerPickerType pickerType;

@property (nonatomic, copy) NSString *enteredDigits;

@property (nonatomic, assign) UIViewController *contentViewController;

- (IBAction)splitAction:(id)sender;
- (IBAction)tipAction:(id)sender;
- (IBAction)amountAction:(id)sender;

@end
