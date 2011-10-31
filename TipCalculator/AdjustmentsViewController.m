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

@interface AdjustmentsViewController (Private)

- (void)resetAction:(id)sender;
- (void)adjustmentsAction:(id)sender;
- (void)deleteAdjustmentConfirmationAction:(id)sender;
- (void)deleteAdjustmentAction:(id)sender;
- (void)addAction:(id)sender;

@end

#define kResetAdjustmentsActionSheetTag 100
#define kDeleteAdjustmentActionSheetTag 101

@implementation AdjustmentsViewController

@synthesize delegate = delegate_;
@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize adjustmentsInputView = adjustmentsInputView_;
@synthesize currentAdjustment = currentAdjustment_;

- (id)init
{
    self = [super initWithNibName:@"AdjustmentsViewController" bundle:nil];
    if (self) {
        check_ = [CheckData sharedCheckData].currentCheck;
        numberPad_ = [[RLNumberPad alloc] initDefaultNumberPad];
        numberPad_.delegate = self;
        numberPadDigits_ = [[RLNumberPadDigits alloc] initWithDigits:@""];
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
    [adjustmentsInputView_ release];
    [currentAdjustment_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
    
    adjustmentsTable_.allowsSelection = NO;
    
    InputDisplayView *adjustmentsInputView = [[InputDisplayView alloc] initWithFrame:CGRectMake(10.0, 105.0, 0.0, 0.0)];
    adjustmentsInputView.titleLabel.text = @"Add Adjustment";
    adjustmentsInputView.inputView = numberPad_;
    [adjustmentsInputView addTarget:self action:@selector(adjustmentsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.adjustmentsInputView = adjustmentsInputView;
    [adjustmentsInputView release];
    numberPad_.callerView = adjustmentsInputView_;
    [self.view addSubview:adjustmentsInputView_];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.adjusmentsTable = nil;
    self.adjustmentsInputView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [numberPadDigits_ setEnteredDigitsWithDecimalNumber:currentAdjustment_];
    adjustmentsInputView_.descriptionLabel.text = [numberPadDigits_ stringForEnteredDigits];
    
    [adjustmentsTable_ reloadData];
}

#pragma mark - Custom Action Methods

- (IBAction)backAction:(id)sender
{
    [delegate_ adjustmentsViewControllerDidFinish:self];
}

- (IBAction)resetConfirmationAction:(id)sender
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
        [adjustmentsInputView_ resignFirstResponder];
        self.currentAdjustment = [NSDecimalNumber zero];
        [numberPadDigits_ setEnteredDigitsWithDecimalNumber:currentAdjustment_];
        adjustmentsInputView_.descriptionLabel.text = [numberPadDigits_ stringForEnteredDigits];
    } else {
        [adjustmentsInputView_ becomeFirstResponder];
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
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (void)addAction:(id)sender
{
    NSComparisonResult adjustmentCompare = [currentAdjustment_ compare:[NSDecimalNumber zero]];
    if (adjustmentCompare != NSOrderedSame) {
        Adjustment *adjustment = [[Adjustment alloc] initWithAmount:currentAdjustment_ tipRate:check_.tipPercentage];
        [check_ addSplitAdjustment:adjustment];
        [adjustment release];
        
        [adjustmentsTable_ beginUpdates];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [adjustmentsTable_ endUpdates];
    }
    [self performSelector:@selector(adjustmentsAction:)];
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
        rows = [check_.splitAdjustments count] + 1;
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
    
    cell.textLabel.text = textStr;
    cell.detailTextLabel.text = detailTextStr;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 44.0;
    if (indexPath.section == 0) {
        height = 59.0;
    }
    return height;
}

#pragma mark - RLNumberPad Delegate Methods

- (void)didPressClearButtonForCallerView:(UIView *)callerView
{
    numberPadDigits_.enteredDigits = @"";
    self.currentAdjustment = [numberPadDigits_ decimalNumberForEnteredDigits];
    adjustmentsInputView_.descriptionLabel.text = [numberPadDigits_ stringForEnteredDigits];
}

- (void)didPressReturnButtonForCallerView:(UIView *)callerView
{
    [self performSelector:@selector(addAction:)];
}

- (void)didPressButtonWithString:(NSString *)string callerView:(UIView *)callerView
{
    [numberPadDigits_ addDigit:string];
	self.currentAdjustment = [numberPadDigits_ decimalNumberForEnteredDigits];
	adjustmentsInputView_.descriptionLabel.text = [numberPadDigits_ stringForEnteredDigits];
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
