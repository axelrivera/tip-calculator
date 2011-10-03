//
//  SummaryViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SummaryViewController.h"
#import "CheckData.h"
#import "Check.h"
#import "RLInputButton.h"

@interface SummaryViewController (Private)

- (void)createPicker;
- (void)showPicker;
- (void)hidePicker;

- (void)createTextField;

- (void)reloadCheckInput;
- (void)reloadCheckSummary;

@end

@implementation SummaryViewController

@synthesize summaryTable = summaryTable_;
@synthesize numberOfSplitStr = numberOfSplitStr_;
@synthesize tipPercentageStr = tipPercentageStr_;
@synthesize amountStr = amountStr_;
@synthesize totalTipStr = totalTipStr_;
@synthesize totalToPayStr = totalToPayStr_;
@synthesize totalPerPersonStr = totalPerPersonStr_;
@synthesize splitButton = splitButton_;
@synthesize tipButton = tipButton_;
@synthesize amountButton = amountButton_;
@synthesize pickerView = pickerView_;
@synthesize currentPickerDataSource = currentPickerDataSource_;
@synthesize pickerType = pickerType_;
@synthesize billTotalTextField  = billTotalTextfield_;
@synthesize contentViewController = contentViewController_;

- (id)init
{
    self = [super initWithNibName:@"SummaryViewController" bundle:nil];
    if (self) {
        checkData_ = [CheckData sharedCheckData];
        self.numberOfSplitStr = @"";
        self.tipPercentageStr = @"";
        self.amountStr = @"";
        self.totalTipStr = @"";
        self.totalToPayStr = @"";
        self.totalPerPersonStr = @"";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [summaryTable_ release];
    [numberOfSplitStr_ release];
    [tipPercentageStr_ release];
    [amountStr_ release];
    [totalTipStr_ release];
    [totalToPayStr_ release];
    [totalPerPersonStr_ release];
    [splitButton_ release];
    [tipButton_ release];
    [amountButton_ release];
    [pickerView_ release];
    [billTotalTextfield_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    summaryTable_.allowsSelection = NO;
    summaryTable_.backgroundColor = [UIColor clearColor];
    summaryTable_.opaque = NO;
    summaryTable_.backgroundView = nil;
    
    [self createPicker];
    
    self.splitButton = [[[RLInputButton alloc] init] autorelease];
    self.tipButton = [[[RLInputButton alloc] init] autorelease];
    self.amountButton = [[[RLInputButton alloc] init] autorelease];
    
    splitButton_.inputView = pickerView_;
    [splitButton_ addTarget:self action:@selector(splitAction:) forControlEvents:UIControlEventTouchUpInside];
    tipButton_.inputView = pickerView_;
    [tipButton_ addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchUpInside];
    [amountButton_ addTarget:self action:@selector(amountAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Create the text field after amountButton_
    [self createTextField];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.summaryTable = nil;
    self.splitButton = nil;
    self.tipButton = nil;
    self.amountButton = nil;
    self.pickerView = nil;
    self.billTotalTextField = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadCheckInput];
    [self reloadCheckSummary];
    [summaryTable_ reloadData];
}

#pragma mark - Private Methods

- (void)createPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    self.pickerView = pickerView;
    [pickerView release];
}

- (void)createTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 150.0, 30.0)];
	textField.font = [UIFont systemFontOfSize:16.0];
	textField.adjustsFontSizeToFitWidth = YES;
	textField.placeholder = @"$0.00";
	textField.keyboardType = UIKeyboardTypeNumberPad;
	textField.textAlignment = UITextAlignmentRight;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.rightView = amountButton_;
    textField.rightViewMode = UITextFieldViewModeAlways;
	textField.delegate = self;
    self.billTotalTextField = textField;
    [textField release];
}

- (void)splitAction:(id)sender
{
    if ([tipButton_ isFirstResponder])
        [tipButton_ resignFirstResponder];
    if ([billTotalTextfield_ isFirstResponder])
        [billTotalTextfield_ resignFirstResponder];
    
    if ([splitButton_ isFirstResponder]) {
        [splitButton_ resignFirstResponder];
        [summaryTable_ reloadData];
    } else {
        pickerType_ = SummaryViewControllerPickerSplit;
        currentPickerDataSource_ = [Check numberOfSplitsArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[checkData_.currentCheck rowForCurrentNumberOfSplits] inComponent:0 animated:NO];
        
        [splitButton_ becomeFirstResponder];
    }
}

- (void)tipAction:(id)sender
{
    if ([splitButton_ isFirstResponder])
        [splitButton_ resignFirstResponder];
    if ([billTotalTextfield_ isFirstResponder])
        [billTotalTextfield_ resignFirstResponder];
    
    if ([tipButton_ isFirstResponder]) {
        [tipButton_ resignFirstResponder];
        [summaryTable_ reloadData];
    } else {
        pickerType_ = SummaryViewControllerPickerPercent;
        currentPickerDataSource_ = [Check tipPercentagesArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[checkData_.currentCheck rowForCurrentTipPercentage] inComponent:0 animated:NO];
        
        [tipButton_ becomeFirstResponder];
    }
}

- (void)amountAction:(id)sender
{
    if ([splitButton_ isFirstResponder])
        [splitButton_ resignFirstResponder];
    if ([tipButton_ isFirstResponder])
        [tipButton_ resignFirstResponder];
    
    if ([billTotalTextfield_ isFirstResponder]) {
        [billTotalTextfield_ resignFirstResponder];
    } else {
        [billTotalTextfield_ becomeFirstResponder];
    }
}

- (void)reloadCheckInput
{
    self.numberOfSplitStr = [checkData_.currentCheck stringForNumberOfSplits];
    self.tipPercentageStr = [checkData_.currentCheck stringForTipPercentage];
    self.amountStr = [checkData_.currentCheck stringForCheckAmount];
}

- (void)reloadCheckSummary
{
    self.totalTipStr = [checkData_.currentCheck stringForTotalTip];
    self.totalToPayStr = [checkData_.currentCheck stringForTotalToPay];
    self.totalPerPersonStr = [checkData_.currentCheck stringForTotalPerPerson];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    NSString *textLabelStr = nil;
    NSString *detailTextLabelStr = nil;

    if (indexPath.section == 0) {
        UIView *accessoryView = nil;
        if (indexPath.row == 0) {
            textLabelStr = @"Split Check";
            detailTextLabelStr = numberOfSplitStr_;
            accessoryView = splitButton_;
        } else if (indexPath.row == 1) {
            textLabelStr = @"Tip Percentage";
            detailTextLabelStr = tipPercentageStr_;
            accessoryView = tipButton_;
        } else {
            textLabelStr = @"Bill Total";
            accessoryView = billTotalTextfield_;
        }
        cell.accessoryView = accessoryView;
    } else {
        if (indexPath.row == 0) {
            textLabelStr = @"Total Tip";
            detailTextLabelStr = totalTipStr_;
        } else if (indexPath.row == 1) {
            textLabelStr = @"Total to Pay";
            detailTextLabelStr = totalToPayStr_;
        } else {
            textLabelStr = @"Total Per Person";
            detailTextLabelStr = totalPerPersonStr_;
        }
    }
    
    cell.textLabel.text = textLabelStr;
    cell.detailTextLabel.text = detailTextLabelStr;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods


#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    NSDecimalNumber *number = [currentPickerDataSource_ objectAtIndex:0];
    if (pickerType_ == SummaryViewControllerPickerSplit) {
        checkData_.currentCheck.numberOfSplits = number;
    } else {
        checkData_.currentCheck.tipPercentage = number;
    }
    [self reloadCheckInput];
    [self reloadCheckSummary];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [currentPickerDataSource_ count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = nil;
    NSDecimalNumber *currentNumber = [currentPickerDataSource_ objectAtIndex:row];
    if (pickerType_ == SummaryViewControllerPickerSplit) {
        string = [checkData_.currentCheck stringForNumberOfSplitsWithDecimalNumber:currentNumber];
    } else {
        string = [checkData_.currentCheck stringForTipPercentageWithDecimalNumber:currentNumber];
    }
    return string;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300.00;
}

@end
