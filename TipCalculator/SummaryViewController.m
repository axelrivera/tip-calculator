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
#import "CheckHelper.h"
#import "NSDecimalNumber+Check.h"
#import "UIButton+TipCalculator.h"

#define kInputLabelWidth 266.0

@interface SummaryViewController (Private)

- (void)splitAction:(id)sender;
- (void)tipAction:(id)sender;
- (void)amountAction:(id)sender;
- (void)showAdjustmentsAction:(id)sender;
- (void)showSettingsAction:(id)sender;
- (void)reloadCheckSummaryAndResetAdjustments:(BOOL)adjustments;

@end

@implementation SummaryViewController

@synthesize splitInputView = splitInputView_;
@synthesize tipInputView = tipInputView_;
@synthesize billAmountInputView = billAmountInputView_;
@synthesize pickerView = pickerView_;
@synthesize currentPickerDataSource = currentPickerDataSource_;
@synthesize pickerType = pickerType_;

- (id)init
{
    self = [super initWithNibName:@"SummaryViewController" bundle:nil];
    if (self) {
        check_ = [CheckData sharedCheckData].currentCheck;
        numberPad_ = [[RLNumberPad alloc] initDefaultNumberPad];
        numberPad_.delegate = self;
        numberPadDigits_ = [[RLNumberPadDigits alloc] initWithDigits:@"" andDecimals:@""];
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
    check_ = nil;
    numberPad_.delegate = nil;
    [numberPad_ release];
    [numberPadDigits_ release];
    [guestCheckView_ release];
    [splitsButton_ release];
    [settingsButton_ release];
    [splitInputView_ release];
    [tipInputView_ release];
    [billAmountInputView_ release];
    [pickerView_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainscreen_background.png"]]];
    
    InputDisplayView *splitInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(27.0, 75.0, kInputLabelWidth, 0.0)];
    splitInputView.textLabel.text = @"Split Check";
    splitInputView.inputView = pickerView_;
    [splitInputView addTarget:self action:@selector(splitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.splitInputView = splitInputView;
    [splitInputView release];
    [self.view addSubview:splitInputView_];
    
    InputDisplayView *tipInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(27.0, 122.0, kInputLabelWidth, 0.0)];
    tipInputView.textLabel.text = @"Tip Percentage";
    tipInputView.inputView = pickerView_;
    [tipInputView addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tipInputView = tipInputView;
    [tipInputView release];
    [self.view addSubview:tipInputView_];
    
    InputDisplayView *billAmountInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(27.0, 169.0, kInputLabelWidth, 0.0)];
    billAmountInputView.textLabel.text = @"Check Amount";
    billAmountInputView.inputView = numberPad_;
    [billAmountInputView addTarget:self action:@selector(amountAction:) forControlEvents:UIControlEventTouchUpInside];
    self.billAmountInputView = billAmountInputView;
    [billAmountInputView release];
    numberPad_.callerView = billAmountInputView_;
    [self.view addSubview:billAmountInputView_];
    
    guestCheckView_ = [[GuestCheckView alloc] initWithFrame:CGRectMake(27.0, 225.0, kInputLabelWidth, 168.0)];
    [self.view addSubview:guestCheckView_];
    
    splitsButton_ = [[UIButton orangeButtonAtPoint:CGPointMake(27.0, 400.0)] retain];
    [splitsButton_ setTitle:@"Splits" forState:UIControlStateNormal];
    [splitsButton_ addTarget:self action:@selector(showAdjustmentsAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:splitsButton_];
    
    settingsButton_ = [[UIButton whiteButtonAtPoint:CGPointZero] retain];
    CGSize settingsSize = CGSizeMake(settingsButton_.frame.size.width, settingsButton_.frame.size.height);
    settingsButton_.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (27.0 + settingsSize.width),
                                       400.0,
                                       settingsSize.width,
                                       settingsSize.height);
    [settingsButton_ setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton_ addTarget:self action:@selector(showSettingsAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:settingsButton_];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [guestCheckView_ release];
    guestCheckView_ = nil;
    [splitsButton_ release];
    splitsButton_ = nil;
    [settingsButton_ release];
    settingsButton_ = nil;
    self.splitInputView = nil;
    self.tipInputView = nil;
    self.billAmountInputView = nil;
    self.pickerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    splitInputView_.detailTextLabel.text = [check_ stringForNumberOfSplitsWithDecimalNumber:check_.numberOfSplits];
    tipInputView_.detailTextLabel.text = [check_.tipPercentage percentString];
    
    [numberPadDigits_ setDigitsAndDecimalsWithDecimalNumber:check_.billAmount];
    billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
    
    [self reloadCheckSummaryAndResetAdjustments:NO];
}

#pragma mark - Custom Actions

- (void)splitAction:(id)sender
{
    if ([tipInputView_ isFirstResponder]) {
        [tipInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    if ([billAmountInputView_ isFirstResponder]) {
        [numberPadDigits_ validateAndFixDecimalSeparator];
        billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
        [billAmountInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    
    if ([splitInputView_ isFirstResponder]) {
        [splitInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    } else {
        pickerType_ = SummaryViewControllerPickerSplit;
        currentPickerDataSource_ = [Check numberOfSplitsArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[check_ rowForCurrentNumberOfSplits] inComponent:0 animated:NO];
        [splitInputView_ becomeFirstResponder];
    }
}

- (void)tipAction:(id)sender
{
    if ([splitInputView_ isFirstResponder]) {
        [splitInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    if ([billAmountInputView_ isFirstResponder]) {
        [numberPadDigits_ validateAndFixDecimalSeparator];
        billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
        [billAmountInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    
    if ([tipInputView_ isFirstResponder]) {
        [tipInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    } else {
        pickerType_ = SummaryViewControllerPickerPercent;
        currentPickerDataSource_ = [Check tipPercentagesArray];
        [pickerView_ reloadAllComponents];
        [pickerView_ selectRow:[check_ rowForCurrentTipPercentage] inComponent:0 animated:NO];
        [tipInputView_ becomeFirstResponder];
    }
}

- (void)amountAction:(id)sender
{
    if ([splitInputView_ isFirstResponder]) {
        [splitInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    if ([tipInputView_ isFirstResponder]) {
        [tipInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    }
    
    if ([billAmountInputView_ isFirstResponder]) {
        [numberPadDigits_ validateAndFixDecimalSeparator];
        billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
        [billAmountInputView_ resignFirstResponder];
        [self reloadCheckSummaryAndResetAdjustments:YES];
    } else {
        [billAmountInputView_ becomeFirstResponder];
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

- (void)reloadCheckSummaryAndResetAdjustments:(BOOL)adjustments
{
    if (![check_.billAmount isEqualToZero]) {
        guestCheckView_.hidden = NO;
        guestCheckView_.totalTipLabel.text = [[check_ totalTip] currencyString];
        guestCheckView_.totalToPayLabel.text = [[check_ totalToPay] currencyString];
        guestCheckView_.totalPerPersonLabel.text = [[check_ totalPerPerson] currencyString];
    } else {
        guestCheckView_.hidden = YES;
    }
    
    if (adjustments) {
        [check_ removeAllSplitAdjustments];
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
    [self reloadCheckSummaryAndResetAdjustments:NO];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDecimalNumber *number = [currentPickerDataSource_ objectAtIndex:row];
    if (pickerType_ == SummaryViewControllerPickerSplit) {
        check_.numberOfSplits = number;
        splitInputView_.detailTextLabel.text = [check_ stringForNumberOfSplitsWithDecimalNumber:check_.numberOfSplits];
    } else {
        check_.tipPercentage = number;
        tipInputView_.detailTextLabel.text = [check_ stringForTipPercentageWithDecimalNumber:check_.tipPercentage];
    }
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
        string = [check_ stringForNumberOfSplitsWithDecimalNumber:currentNumber];
    } else {
        NSComparisonResult isZero = [currentNumber compare:[NSDecimalNumber zero]];
        if (isZero == NSOrderedSame) {
            string = [check_ stringForTipPercentageWithDecimalNumber:currentNumber];
        } else {
            NSString *tmpStr = nil;
            NSString *percentage = [check_ stringForTipPercentageWithDecimalNumber:currentNumber];
            tmpStr = [percentage stringByPaddingToLength:15 withString:@" " startingAtIndex:0];
            NSString *tip = [[CheckHelper calculateTipWithAmount:check_.billAmount andRate:currentNumber] currencyString];
            string = [NSString stringWithFormat:@"%@%@", tmpStr, tip];
        }
    }
    return string;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300.00;
}

#pragma mark - RLNumberPad Delegate Methods

- (void)didPressClearButtonForCallerView:(UIView *)callerView
{
    [numberPadDigits_ resetDigitsAndDecimals];
    check_.billAmount = [numberPadDigits_ decimalNumber];
    billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
}

- (void)didPressReturnButtonForCallerView:(UIView *)callerView
{
    [self performSelector:@selector(amountAction:)];
}

- (void)didPressButtonWithString:(NSString *)string callerView:(UIView *)callerView
{
    [numberPadDigits_ addNumber:string];
	check_.billAmount = [numberPadDigits_ decimalNumber];
	billAmountInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
}

@end
