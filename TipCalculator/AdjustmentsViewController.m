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
#import "ControllerConstants.h"
#import "UIColor+TipCalculator.h"
#import "UIButton+TipCalculator.h"
#import "AdjustmentViewCell.h"
#import "AdjustmentView.h"
#import "Settings.h"

@interface AdjustmentsViewController (Private)

- (void)backAction:(id)sender;
- (void)resetConfirmationAction:(id)sender;
- (void)resetAction:(id)sender;
- (void)adjustmentsAction:(id)sender;
- (void)deleteAdjustmentConfirmationAction:(id)sender;
- (void)deleteAdjustmentAction:(id)sender;
- (void)addAdjustmentConfirmationAction:(id)sender;
- (void)addAdjustmentAction:(id)sender;
- (void)questionAction:(id)sender;
- (void)validateAdjustments;
- (void)clearAdjustmentInput;

- (NSString *)stringForAmount:(NSString *)amount tip:(NSString *)tip;
- (NSString *)stringForPeopleLeft;

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
@synthesize totalToPayTitleLabel = totalToPayTitleLabel_;
@synthesize totalToPayLabel = totalToPayLabel_;
@synthesize numberOfPeopleLabel = numberOfPeopleLabel_;
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
        currentDeleteButton_ = nil;
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
	[totalToPayTitleLabel_ release];
	[totalToPayLabel_ release];
	[numberOfPeopleLabel_ release];
    [currentAdjustment_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenBoardColor];
	
	adjustmentsTable_.backgroundColor = [UIColor greenBoardColor];
	adjustmentsTable_.rowHeight = 65.0;
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, 97.0)];
	headerView_.opaque = NO;
	headerView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"adjustment_header_bg.png"]];
	[self.view addSubview:headerView_];
	
	backButton_ = [[UIButton greenButtonAtPoint:CGPointMake(10.0, 10.0)] retain];
    [backButton_ setTitle:@"Back" forState:UIControlStateNormal];
    [backButton_ addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchDown];
    [headerView_ addSubview:backButton_];
    
    resetButton_ = [[UIButton redButtonAtPoint:CGPointZero] retain];
    CGSize resetSize = CGSizeMake(resetButton_.frame.size.width, resetButton_.frame.size.height);
    resetButton_.frame = CGRectMake(screenSize.width - (10.0 + resetSize.width),
                                       10.0,
                                       resetSize.width,
                                       resetSize.height);
    [resetButton_ setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton_ addTarget:self action:@selector(resetConfirmationAction:) forControlEvents:UIControlEventTouchDown];
    [headerView_ addSubview:resetButton_];
    
	
    CGFloat inputViewWidth = screenSize.width - (10.0 + 10.0 + 30.0 + 10.0);
    InputDisplayView *adjustmentsInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(10.0, 50.0, inputViewWidth, 0.0)];
	
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
	questionButton_.frame = CGRectMake(10.0 + inputViewWidth + 10.0, 54.0, 30.0, 30.0);
	[questionButton_ setBackgroundImage:[UIImage imageNamed:@"button_question.png"] forState:UIControlStateNormal];
	[questionButton_ setBackgroundImage:[UIImage imageNamed:@"button_question_pressed.png"] forState:UIControlStateHighlighted];
	[questionButton_ addTarget:self action:@selector(questionAction:) forControlEvents:UIControlEventTouchDown];
	questionButton_.adjustsImageWhenHighlighted = NO;
	[headerView_ addSubview:questionButton_];
	
	footerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, screenSize.height - (37.0 + 20.0), screenSize.width, 37.0)];
	footerView_.opaque = NO;
	footerView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"adjustment_footer_bg.png"]];
	[self.view addSubview:footerView_];
	
	totalToPayTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 110.0, 27.0)];
	totalToPayTitleLabel_.backgroundColor = [UIColor clearColor];
	totalToPayTitleLabel_.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:16.0];
	totalToPayTitleLabel_.textColor = [UIColor purpleChalkColor];
	totalToPayTitleLabel_.textAlignment = UITextAlignmentLeft;
	totalToPayTitleLabel_.text = @"Total to Pay:";
	[footerView_ addSubview:totalToPayTitleLabel_];
	
	totalToPayLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 5.0, 125.0, 27.0)];
	totalToPayLabel_.backgroundColor = [UIColor clearColor];
	totalToPayLabel_.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:16.0];
	totalToPayLabel_.textColor = [UIColor greenBoardColor];
	totalToPayLabel_.textAlignment = UITextAlignmentLeft;
	totalToPayLabel_.minimumFontSize = 12.0;
	totalToPayLabel_.adjustsFontSizeToFitWidth = YES;
	[footerView_ addSubview:totalToPayLabel_];
	
	numberOfPeopleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 5.0, 60.0, 27.0)];
	numberOfPeopleLabel_.backgroundColor = [UIColor clearColor];
	numberOfPeopleLabel_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
	numberOfPeopleLabel_.textColor = [UIColor greenBoardColor];
	numberOfPeopleLabel_.textAlignment = UITextAlignmentRight;
	numberOfPeopleLabel_.minimumFontSize = 12.0;
	numberOfPeopleLabel_.adjustsFontSizeToFitWidth = YES;
	[footerView_ addSubview:numberOfPeopleLabel_];
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
	self.totalToPayTitleLabel = nil;
	self.totalToPayLabel = nil;
	self.numberOfPeopleLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [numberPadDigits_ setDigitsAndDecimalsWithDecimalNumber:currentAdjustment_];
	[numberPadDigits_ validateAndFixDecimalSeparator];
    adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
    
	[self validateAdjustments];
	
	NSDecimalNumber *totalToPay = [check_ totalToPay];
	NSDecimalNumber *numberOfPeople = [check_ numberOfSplits];
	
	totalToPayLabel_.text = [totalToPay currencyString];
	numberOfPeopleLabel_.text = [check_ stringForNumberOfSplitsWithDecimalNumber:numberOfPeople];
	
    [adjustmentsTable_ reloadData];
}

#pragma mark - Custom Action Methods

- (void)backAction:(id)sender
{
    [delegate_ adjustmentsViewControllerDidFinish:self];
}

- (void)resetConfirmationAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete All Adjustments?"
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
	[self validateAdjustments];
    [adjustmentsTable_ beginUpdates];
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]
                     withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (void)adjustmentsAction:(id)sender
{
    if ([adjustmentsInputView_ isFirstResponder]) {
        [self clearAdjustmentInput];
    } else {
        [adjustmentsInputView_ becomeFirstResponder];
    }
}

- (void)deleteAdjustmentConfirmationAction:(id)sender
{
    currentDeleteButton_ = (UIButton *)sender;
	NSString *title = [NSString stringWithFormat:@"Delete Adjustment #%d?", currentDeleteButton_.tag + 1];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
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
	[self validateAdjustments];
    [adjustmentsTable_ beginUpdates];
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]
                     withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (void)addAdjustmentConfirmationAction:(id)sender
{
	if ([currentAdjustment_ compare:[NSDecimalNumber zero]] == NSOrderedSame) {
		[self clearAdjustmentInput];
		return;
	}
	
	if ([Settings sharedSettings].adjustmentConfirmation) {
		Settings *settings = [Settings sharedSettings];
		NSDecimalNumber *tax = [currentAdjustment_ decimalCurrencyByMultiplyingBy:[settings taxRatePercentage]];
		NSDecimalNumber *taxRate = [[NSDecimalNumber one] decimalNumberByAdding:[settings taxRatePercentage]];
		NSDecimalNumber *newAdjustment = [currentAdjustment_ decimalCurrencyByMultiplyingBy:taxRate];
		Adjustment *adjustment = [[[Adjustment alloc] initWithAmount:newAdjustment tipRate:check_.tipPercentage] autorelease];
		
		NSString *adjustmentString = [currentAdjustment_ currencyString];
		NSString *taxString = [tax currencyString];
		NSString *tipString = [adjustment.tip currencyString];
		NSString *totalString = [adjustment.total currencyString];
		
		NSString *message = [NSString stringWithFormat:
							 @"Adjustment: %@\n"
							 @"Tax: %@\n"
							 @"Tip: %@\n"
							 @"Total: %@",
							 adjustmentString,
							 taxString,
							 tipString,
							 totalString];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Adjustment Confirmation"
															message:message
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Add", nil];
		[alertView show];
		[alertView release];
	} else {
		[self performSelector:@selector(addAdjustmentAction:)];
	}
}

- (void)addAdjustmentAction:(id)sender
{	
	Settings *settings = [Settings sharedSettings];
    NSDecimalNumber *taxRate = [[NSDecimalNumber one] decimalNumberByAdding:[settings taxRatePercentage]];
	NSDecimalNumber *newAdjustment = [currentAdjustment_ decimalCurrencyByMultiplyingBy:taxRate];
    Adjustment *adjustment = [[[Adjustment alloc] initWithAmount:newAdjustment tipRate:check_.tipPercentage] autorelease];
	[check_ addSplitAdjustment:adjustment];
	[self validateAdjustments];
	[adjustmentsTable_ beginUpdates];
	[adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[adjustmentsTable_ endUpdates];
	[self clearAdjustmentInput];
}

- (void)questionAction:(id)sender
{
	
}

#pragma mark - Private Methods

- (void)validateAdjustments
{
	NSComparisonResult hasNoSplit = [[check_ numberOfSplits] compare:[NSDecimalNumber one]];
	NSComparisonResult hasZeroTotal = [[check_ totalToPay] compare:[NSDecimalNumber zero]];
	if (hasNoSplit == NSOrderedSame ||
		hasZeroTotal == NSOrderedSame ||
		[check_ canAddOneMoreAdjusment] == NO ||
		[check_ currentBalanceEqualToZeroOrNegative] == YES) {
		adjustmentsInputView_.enabled = NO;
		if (hasNoSplit == NSOrderedSame || hasZeroTotal == NSOrderedSame) {
			resetButton_.enabled = NO;
		}
	} else {
		adjustmentsInputView_.enabled = YES;
		resetButton_.enabled = YES;
	}
}

- (void)clearAdjustmentInput
{
	[adjustmentsInputView_ resignFirstResponder];
	self.currentAdjustment = [NSDecimalNumber zero];
	[numberPadDigits_ setDigitsAndDecimalsWithDecimalNumber:currentAdjustment_];
	[numberPadDigits_ validateAndFixDecimalSeparator];
	adjustmentsInputView_.detailTextLabel.text = [numberPadDigits_ stringValue];
}

- (NSString *)stringForAmount:(NSString *)amount tip:(NSString *)tip
{
	return [NSString stringWithFormat:@"%@ + tip %@", amount, tip];
}

- (NSString *)stringForPeopleLeft
{
	return [NSString stringWithFormat:@"%d People Left",
			[[check_ numberOfSplitsLeftAfterAdjustment] integerValue]];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = [check_.splitAdjustments count];
	if ([[check_ splitAdjustments] count] < [check_.numberOfSplits integerValue]) {
		rows++;
	}
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    AdjustmentViewCell *cell = (AdjustmentViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AdjustmentViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		AdjustmentView *adjustmentView = [[AdjustmentView alloc] initWithFrame:CGRectZero];
		cell.adjustmentView = adjustmentView;
		[adjustmentView release];
    }
    
    NSString *text1Str = nil;
	NSString *text2Str = nil;
    NSString *detailText1Str = nil;
	NSString *detailText2Str = nil;
    
    if (indexPath.row < [check_.splitAdjustments count]) {
        Adjustment *adjustment = [check_.splitAdjustments objectAtIndex:indexPath.row];
		
		text1Str = [NSString stringWithFormat:@"Adjustment #%d", indexPath.row + 1];
		
		detailText1Str = [[adjustment total] currencyString];
		detailText2Str = [self stringForAmount:[adjustment.amount currencyString]
										   tip:[adjustment.tip currencyString]];
        
        UIButton *deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        deleteButton.frame = CGRectMake(0.0, 0.0, 25.0, 30.0);
        deleteButton.tag = indexPath.row;
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"button_delete.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAdjustmentConfirmationAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = deleteButton;
        [deleteButton release];
		[cell.adjustmentView setRowTextColor];
    } else {
        NSDecimalNumber *totalBalancePerPerson = [check_ totalBalancePerPersonAfterAdjustments];
        NSDecimalNumber *billAmountBalancePerPerson = [check_ billAmountBalancePerPersonAfterAdjustments];
        NSDecimalNumber *tipBalancePerPerson = [check_ tipBalancePerPersonAfterAdjustments];
        
		if ([[check_ numberOfSplits] compare:[NSDecimalNumber one]] == NSOrderedSame) {
			text1Str = @"Total To Pay";
			text2Str = [check_ stringForNumberOfSplitsWithDecimalNumber:check_.numberOfSplits];
			detailText1Str = [totalBalancePerPerson currencyString];
			detailText2Str = [self stringForAmount:[billAmountBalancePerPerson currencyString]
											   tip:[tipBalancePerPerson currencyString]];
		} else {
			if ([check_ currentBalanceEqualToZeroOrNegative]) {
				if ([check_ currentBalanceEqualToZero]) {
					text1Str = @"Balance";
				} else {
					text1Str = @"Negative Balance";
				}
				text2Str = [self stringForPeopleLeft];
				detailText1Str = [[check_ totalBalanceAfterAdjustments] currencyString];
				detailText2Str = nil;
			} else {
				text1Str = @"Balance Per Person";
				text2Str = [self stringForPeopleLeft];
				detailText1Str = [totalBalancePerPerson currencyString];
				detailText2Str = [self stringForAmount:[billAmountBalancePerPerson currencyString]
												   tip:[tipBalancePerPerson currencyString]];
			}
		}
		
        cell.accessoryView = nil;
		[cell.adjustmentView setSummaryTextColor];
    }
    
    cell.adjustmentView.textLabel1.text = text1Str;
	cell.adjustmentView.textLabel2.text = text2Str;
	cell.adjustmentView.detailTextLabel1.text = detailText1Str;
	cell.adjustmentView.detailTextLabel2.text = detailText2Str;
	
	NSString *backgroundName = @"adjustment_row_first_bg.png";
	if (indexPath.row % 2 == 0) {
		if (indexPath.row > 0) {
			backgroundName = @"adjustment_row_bg.png";
		}
	} else {
		backgroundName = @"adjustment_row_alt_bg.png";
	}
	
	UIView *backgroundView = [[UIView alloc]initWithFrame:cell.frame];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundName]];
	cell.backgroundView = backgroundView;
	[backgroundView release];
    
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
    [self performSelector:@selector(addAdjustmentConfirmationAction:)];
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

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self clearAdjustmentInput];
	} else {
		[self performSelector:@selector(addAdjustmentAction:)];
	}
}

@end
