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

#define kCurrencyScale -2
#define kMaxDigits 9

@interface SummaryViewController (Private)

- (void)reloadCheckSummary;

@end

@implementation SummaryViewController

@synthesize splitButton = splitButton_;
@synthesize tipButton = tipButton_;
@synthesize amountButton = amountButton_;
@synthesize splitLabel = splitLabel_;
@synthesize tipPercentageLabel = tipPercentageLabel_;
@synthesize billAmountTextField  = billAmountTextField_;
@synthesize checkSummaryView = checkSummaryView_;
@synthesize totalTipLabel = totalTipLabel_;
@synthesize totalToPayLabel = totalToPayLabel_;
@synthesize totalPerPersonLabel = totalPerPersonLabel_;
@synthesize pickerView = pickerView_;
@synthesize currentPickerDataSource = currentPickerDataSource_;
@synthesize pickerType = pickerType_;
@synthesize enteredDigits = enteredDigits_;

- (id)init
{
    self = [super initWithNibName:@"SummaryViewController" bundle:nil];
    if (self) {
        checkData_ = [CheckData sharedCheckData];
        formatter_ = [[NSNumberFormatter alloc] init];
		[formatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
        self.enteredDigits = @"";
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
    [formatter_ release];
    [splitButton_ release];
    [tipButton_ release];
    [amountButton_ release];
    [splitLabel_ release];
    [tipPercentageLabel_ release];
    [billAmountTextField_ release];
    [checkSummaryView_ release];
    [totalTipLabel_ release];
    [totalToPayLabel_ release];
    [totalPerPersonLabel_ release];
    [pickerView_ release];
    [enteredDigits_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
    splitButton_.inputView = pickerView_;
    [splitButton_ addTarget:self action:@selector(splitAction:) forControlEvents:UIControlEventTouchUpInside];
    tipButton_.inputView = pickerView_;
    [tipButton_ addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchUpInside];
    [amountButton_ addTarget:self action:@selector(amountAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.splitButton = nil;
    self.tipButton = nil;
    self.amountButton = nil;
    self.splitLabel = nil;
    self.tipPercentageLabel = nil;
    self.billAmountTextField = nil;
    self.checkSummaryView = nil;
    self.totalTipLabel = nil;
    self.totalToPayLabel = nil;
    self.totalPerPersonLabel = nil;
    self.pickerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    splitLabel_.text = [checkData_.currentCheck stringForNumberOfSplits];
    tipPercentageLabel_.text = [checkData_.currentCheck stringForTipPercentage];
    
    NSString *textFieldStr = nil;
    if ([checkData_.currentCheck.checkAmount floatValue] > 0.0) {
		textFieldStr = [formatter_ stringFromNumber:checkData_.currentCheck.checkAmount];
	} else {
		textFieldStr = @"";
	}
    billAmountTextField_.text = textFieldStr;
    [self reloadCheckSummary];
}

#pragma mark - Custom Actions

- (IBAction)splitAction:(id)sender
{
    if ([tipButton_ isFirstResponder])
        [tipButton_ resignFirstResponder];
    if ([billAmountTextField_ isFirstResponder])
        [billAmountTextField_ resignFirstResponder];
    
    if ([splitButton_ isFirstResponder]) {
        [splitButton_ resignFirstResponder];
    } else {
        pickerType_ = SummaryViewControllerPickerSplit;
        currentPickerDataSource_ = [Check numberOfSplitsArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[checkData_.currentCheck rowForCurrentNumberOfSplits] inComponent:0 animated:NO];
        [splitButton_ becomeFirstResponder];
    }
}

- (IBAction)tipAction:(id)sender
{
    if ([splitButton_ isFirstResponder])
        [splitButton_ resignFirstResponder];
    if ([billAmountTextField_ isFirstResponder])
        [billAmountTextField_ resignFirstResponder];
    
    if ([tipButton_ isFirstResponder]) {
        [tipButton_ resignFirstResponder];
    } else {
        pickerType_ = SummaryViewControllerPickerPercent;
        currentPickerDataSource_ = [Check tipPercentagesArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[checkData_.currentCheck rowForCurrentTipPercentage] inComponent:0 animated:NO];
        [tipButton_ becomeFirstResponder];
    }
}

- (IBAction)amountAction:(id)sender
{
    if ([splitButton_ isFirstResponder])
        [splitButton_ resignFirstResponder];
    if ([tipButton_ isFirstResponder])
        [tipButton_ resignFirstResponder];
    
    if ([billAmountTextField_ isFirstResponder]) {
        [billAmountTextField_ resignFirstResponder];
    } else {
        [billAmountTextField_ becomeFirstResponder];
    }
}

- (IBAction)showAdjustmentsAction:(id)sender
{
    AdjustmentsViewController *controller = [[AdjustmentsViewController alloc] init];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)showSettingsAction:(id)sender
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	[settingsViewController release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

#pragma mark - Private Methods

- (void)reloadCheckSummary
{
    CGFloat total = [checkData_.currentCheck.checkAmount floatValue];
    if (total > 0.00) {
        checkSummaryView_.hidden = NO;
        totalTipLabel_.text = [checkData_.currentCheck stringForTotalTip];
        totalToPayLabel_.text = [checkData_.currentCheck stringForTotalToPay];
        totalPerPersonLabel_.text = [checkData_.currentCheck stringForTotalPerPerson];
        [checkData_.currentCheck splitAdjustmentsEvenly];
    } else {
        checkSummaryView_.hidden = YES;
    }
}

#pragma mark - UIViewController Delegate Methods

- (void)adjustmentsViewControllerDidFinish:(AdjustmentsViewController *)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDecimalNumber *number = [currentPickerDataSource_ objectAtIndex:row];
    if (pickerType_ == SummaryViewControllerPickerSplit) {
        checkData_.currentCheck.numberOfSplits = number;
        splitLabel_.text = [checkData_.currentCheck stringForNumberOfSplits];
    } else {
        checkData_.currentCheck.tipPercentage = number;
        tipPercentageLabel_.text = [checkData_.currentCheck stringForTipPercentage];
    }
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

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    amountButton_.selected = YES;
    
    NSDecimalNumber *amount = checkData_.currentCheck.checkAmount;
	if ([amount floatValue] > 0.0) {
		NSDecimalNumber *digits = [amount decimalNumberByMultiplyingByPowerOf10:abs(kCurrencyScale)];
		self.enteredDigits = [digits stringValue];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    amountButton_.selected = NO;
    [self reloadCheckSummary];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
	//NSLog(@"Entered Digits (change start): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change start): %@", self.currentPrice);
	
	if ([string isEqualToString:@"0"] && [enteredDigits_ length] == 0) {
		return NO;
	}
	
	// Check the length of the string
	if ([string length] > 0) {
        if ([enteredDigits_ length] + 1 <= kMaxDigits) {
            self.enteredDigits = [enteredDigits_ stringByAppendingFormat:@"%d", [string integerValue]];
        }
	} else {
		// This is a backspace
		NSUInteger len = [enteredDigits_ length];
		if (len > 1) {
			self.enteredDigits = [enteredDigits_ substringWithRange:NSMakeRange(0, len - 1)];
		} else {
			self.enteredDigits = @"";
		}
	}
	
	NSDecimalNumber *number = nil;
	
	if (![enteredDigits_ isEqualToString:@""]) {
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:enteredDigits_];
		number = [decimal decimalNumberByMultiplyingByPowerOf10:kCurrencyScale];
	} else {
		number = [NSDecimalNumber zero];
	}
	
	checkData_.currentCheck.checkAmount = number;
	// Replace the text with the localized decimal number
	textField.text = [formatter_ stringFromNumber:number];
	
	//NSLog(@"Entered Digits (change end): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change end): %@", self.currentPrice);
	
	return NO;  
}

@end
