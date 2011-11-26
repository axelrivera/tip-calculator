//
//  AdjustmentsViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentsViewController.h"
#import "CheckHelper.h"
#import "CheckData.h"
#import "Adjustment.h"
#import "NSDecimalNumber+Check.h"
#import "AdjustmentBalanceView.h"
#import "ControllerConstants.h"
#import "UIColor+TipCalculator.h"
#import "UIButton+TipCalculator.h"

@interface AdjustmentsViewController (Private)

- (void)backAction:(id)sender;
- (void)resetConfirmationAction:(id)sender;
- (void)resetAction:(id)sender;
- (void)adjustmentsAction:(id)sender;
- (void)deleteAdjustmentConfirmationAction:(id)sender;
- (void)deleteAdjustmentAction:(id)sender;
- (void)addAction:(id)sender;
- (void)questionAction:(id)sender;

@end

@implementation AdjustmentsViewController

@synthesize delegate = delegate_;
@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize headerView = headerView_;
@synthesize footerView = footerView_;
@synthesize backButton = backButton_;
@synthesize resetButton = resetButton_;
@synthesize questionButton = questionButton_;
@synthesize adjustmentsInputView = adjustmentsInputView_;
@synthesize currentAdjustment = currentAdjustment_;

- (id)init
{
    self = [super initWithNibName:@"AdjustmentsViewController" bundle:nil];
    if (self) {
        check_ = [CheckData sharedCheckData].currentCheck;
        numberPad_ = [[RLNumberPad alloc] initDefaultNumberPad];
        numberPad_.delegate = self;
        numberPadDigits_ = [[RLNumberPadDigits alloc] initWithDigits:@"" andDecimals:@""];
        self.currentAdjustment = [NSDecimalNumber zero];
        currentDeleteButton_ = currentDeleteButton_;
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
    delegate_ = nil;
    numberPad_.delegate = nil;
    [numberPad_ release];
    [numberPadDigits_ release];
    [adjustmentsTable_ release];
	[headerView_ release];
	[footerView_ release];
	[backButton_ release];
	[resetButton_ release];
	[questionButton_ release];
    [adjustmentsInputView_ release];
    [currentAdjustment_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenBoardColor];
	
	adjustmentsTable_.backgroundColor = [UIColor greenBoardColor];
    adjustmentsTable_.allowsSelection = NO;
	adjustmentsTable_.rowHeight = 72.0;
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, 88.0)];
	headerView_.opaque = NO;
	headerView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"adjustment_header_bg.png"]];
	[self.view addSubview:headerView_];
	
	backButton_ = [[UIButton greenButtonAtPoint:CGPointMake(10.0, 5.0)] retain];
    [backButton_ setTitle:@"Back" forState:UIControlStateNormal];
    [backButton_ addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchDown];
    [headerView_ addSubview:backButton_];
    
    resetButton_ = [[UIButton redButtonAtPoint:CGPointZero] retain];
    CGSize resetSize = CGSizeMake(resetButton_.frame.size.width, resetButton_.frame.size.height);
    resetButton_.frame = CGRectMake(screenSize.width - (10.0 + resetSize.width),
                                       5.0,
                                       resetSize.width,
                                       resetSize.height);
    [resetButton_ setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton_ addTarget:self action:@selector(resetConfirmationAction:) forControlEvents:UIControlEventTouchDown];
    [headerView_ addSubview:resetButton_];
    
	
    CGFloat inputViewWidth = screenSize.width - (10.0 + 10.0 + 30.0 + 10.0);
    InputDisplayView *adjustmentsInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(10.0, 44.0, inputViewWidth, 0.0)];
	
	adjustmentsInputView.textColor = [UIColor whiteColor];
	adjustmentsInputView.textColorSelected = [UIColor greenBoardColor];
	adjustmentsInputView.imageAccessory = [UIImage imageNamed:@"input_accessory_down_white.png"];
	adjustmentsInputView.imageAccessorySelected = [UIImage imageNamed:@"input_accessory_up_green.png"];
	
	UIImage *normalImage = [UIImage imageNamed:@"select_view_green.png"];
	UIImage *normalBackground = [normalImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37.0];
	[adjustmentsInputView setBackgroundImage:normalBackground forState:UIControlStateNormal];
	
	UIImage *selectedImage = [UIImage imageNamed:@"select_view_yellow.png"];
	UIImage *selectedBackground = [selectedImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37];
	[adjustmentsInputView setBackgroundImage:selectedBackground forState:UIControlStateSelected];
	
    adjustmentsInputView.textLabel.text = @"Add Adjustment";
    adjustmentsInputView.inputView = numberPad_;
    [adjustmentsInputView addTarget:self action:@selector(adjustmentsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.adjustmentsInputView = adjustmentsInputView;
    [adjustmentsInputView release];
    numberPad_.callerView = adjustmentsInputView_;
    [headerView_ addSubview:adjustmentsInputView_];
	
	questionButton_ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	questionButton_.frame = CGRectMake(10.0 + inputViewWidth + 10.0, 48.0, 30.0, 30.0);
	[questionButton_ setBackgroundImage:[UIImage imageNamed:@"button_question.png"] forState:UIControlStateNormal];
	[questionButton_ addTarget:self action:@selector(questionAction:) forControlEvents:UIControlEventTouchDown];
	[headerView_ addSubview:questionButton_];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.adjusmentsTable = nil;
	self.headerView = nil;
	self.footerView = nil;
	self.backButton = nil;
	self.resetButton = nil;
	self.questionButton = nil;
    self.adjustmentsInputView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [numberPadDigits_ setDigitsAndDecimalsWithDecimalNumber:currentAdjustment_];
    adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
    
    [adjustmentsTable_ reloadData];
}

#pragma mark - Custom Action Methods

- (void)backAction:(id)sender
{
    [delegate_ adjustmentsViewControllerDidFinish:self];
}

- (void)resetConfirmationAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Reset Adjustments"
                                                    otherButtonTitles:nil];
    actionSheet.tag = kResetAdjustmentsActionSheetTag;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)resetAction:(id)sender
{
    [check_ removeAllSplitAdjustments];
    [adjustmentsTable_ beginUpdates];
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]
                     withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (void)adjustmentsAction:(id)sender
{
    if ([adjustmentsInputView_ isFirstResponder]) {
        [numberPadDigits_ validateAndFixDecimalSeparator];
        [adjustmentsInputView_ resignFirstResponder];
        self.currentAdjustment = [NSDecimalNumber zero];
        [numberPadDigits_ setDigitsAndDecimalsWithDecimalNumber:currentAdjustment_];
        adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
    } else {
        if ([check_ canAddOneMoreAdjusment]) {
            [adjustmentsInputView_ becomeFirstResponder];
        } else {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Adjustment Error"
                                                                 message:@"Cannot add more adjustments"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];
            [alertView show];
            return;
        }
    }
}

- (void)deleteAdjustmentConfirmationAction:(id)sender
{
    currentDeleteButton_ = (UIButton *)sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete Adjustment"
                                                    otherButtonTitles:nil];
    actionSheet.tag = kDeleteAdjustmentActionSheetTag;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)deleteAdjustmentAction:(id)sender
{
    NSInteger row = currentDeleteButton_.tag;
    currentDeleteButton_ = nil;
    [check_ removeSplitAdjustmentAtIndex:row];
    [adjustmentsTable_ beginUpdates];
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]
                     withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (void)addAction:(id)sender
{
    Settings *settings = [Settings sharedSettings];
    NSDecimalNumber *taxRate = [[NSDecimalNumber one] decimalNumberByAdding:[settings taxRatePercentage]];
    NSDecimalNumber *newAdjustment = [currentAdjustment_ decimalCurrencyByMultiplyingBy:taxRate];
    Adjustment *adjustment = [[Adjustment alloc] initWithAmount:newAdjustment tipRate:check_.tipPercentage];
    if ([check_ canAddAdjustment:[adjustment total]]) {
        [check_ addSplitAdjustment:adjustment];
        [adjustmentsTable_ beginUpdates];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [adjustmentsTable_ endUpdates];
        [self performSelector:@selector(adjustmentsAction:)];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Adjustment Error"
                                                        message:@"Adjustment Error"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [adjustment release];
}

- (void)questionAction:(id)sender
{
	
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    if (section == 1) {
        rows = [check_.splitAdjustments count];
        if ([[check_ splitAdjustments] count] < [check_.numberOfSplits integerValue]) {
            rows++;
        }
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"BalanceCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        AdjustmentBalanceView *adjustmentView = [[[AdjustmentBalanceView alloc] initWithFrame:CGRectZero] autorelease];
        
        NSDecimalNumber *totalToPay = [check_ totalToPay];
        NSDecimalNumber *numberOfPeople = [check_ numberOfSplits];
        
        NSString *totalToPayStr = [totalToPay currencyString];
        NSString *numberOfPeopleStr = [check_ stringForNumberOfSplitsWithDecimalNumber:numberOfPeople];
        NSString *line1Str = [NSString stringWithFormat:@"Total to Pay: %@ (%@)", totalToPayStr, numberOfPeopleStr];
        
        NSDecimalNumber *totalBalance = [check_ totalBalanceAfterAdjustments];
        NSDecimalNumber *billAmountBalance = [check_ billAmountBalanceAfterAdjustments];
        NSDecimalNumber *tipBalance = [check_ tipBalanceAfterAdjustments];
        
        NSString *totalBalanceStr = [totalBalance currencyString];
        NSString *billAmountBalanceStr = [billAmountBalance currencyString];
        NSString *tipBalanceStr = [tipBalance currencyString];
        NSString *line2Str = [NSString stringWithFormat:@"Balance: %@ = %@ + tip %@",
                              totalBalanceStr,
                              billAmountBalanceStr,
                              tipBalanceStr];
        
        adjustmentView.line1.text = line1Str;
        adjustmentView.line2.text = line2Str;
        
        cell.accessoryView = adjustmentView;
        
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *textStr = nil;
    NSString *detailTextStr = nil;
    
    if (indexPath.row < [check_.splitAdjustments count]) {
        Adjustment *adjustment = [check_.splitAdjustments objectAtIndex:indexPath.row];
        textStr = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                   [[adjustment total] currencyString],
                   [adjustment.amount currencyString],
                   [adjustment.tip currencyString]];
        
        detailTextStr = [NSString stringWithFormat:@"Adjustment #%d", indexPath.row + 1];
        
        UIButton *deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        deleteButton.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        deleteButton.tag = indexPath.row;
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"button_pressed.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAdjustmentConfirmationAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = deleteButton;
        [deleteButton release];
    } else {
        NSDecimalNumber *totalBalancePerPerson = [check_ totalBalancePerPersonAfterAdjustments];
        NSDecimalNumber *billAmountBalancePerPerson = [check_ billAmountBalancePerPersonAfterAdjustments];
        NSDecimalNumber *tipBalancePerPerson = [check_ tipBalancePerPersonAfterAdjustments];
        
        NSString *totalBalancePerPersonStr = [totalBalancePerPerson currencyString];
        NSString *billAmountBalancePerPersonStr = [billAmountBalancePerPerson currencyString];
        NSString *tipBalancePerPersonStr = [tipBalancePerPerson currencyString];
        
        textStr = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                   totalBalancePerPersonStr,
                   billAmountBalancePerPersonStr,
                   tipBalancePerPersonStr];
        detailTextStr = [NSString stringWithFormat:@"Balance Per Person (%d Left)",
                         [[check_ numberOfSplitsLeftAfterAdjustment] integerValue]];
        cell.accessoryView = nil;
    }
	
	UIColor *backgroundColor = nil;
	if ((indexPath.row % 2) == 0) {
		backgroundColor = [UIColor greenBoardColor];
	} else {
		backgroundColor = [UIColor lightGreenBoardColor];
	}
	
	cell.backgroundColor = backgroundColor;
    
    cell.textLabel.text = textStr;
    cell.detailTextLabel.text = detailTextStr;
    
    return cell;
}

#pragma mark - RLNumberPad Delegate Methods

- (void)didPressClearButtonForCallerView:(UIView *)callerView
{
    [numberPadDigits_ resetDigitsAndDecimals];
    self.currentAdjustment = [numberPadDigits_ decimalNumber];
    adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
}

- (void)didPressReturnButtonForCallerView:(UIView *)callerView
{
    [self performSelector:@selector(addAction:)];
}

- (void)didPressButtonWithString:(NSString *)string callerView:(UIView *)callerView
{
    [numberPadDigits_ addNumber:string];
	self.currentAdjustment = [numberPadDigits_ decimalNumber];
	adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kResetAdjustmentsActionSheetTag) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(resetAction:)];
        }
    } else if (actionSheet.tag == kDeleteAdjustmentActionSheetTag) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(deleteAdjustmentAction:)];
        }
    }
}

@end
