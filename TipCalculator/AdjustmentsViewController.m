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

@end

@implementation AdjustmentsViewController

@synthesize delegate = delegate_;
@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize adjustmentTextField = adjustmentTextField_;

- (id)init
{
    self = [super initWithNibName:@"AdjustmentsViewController" bundle:nil];
    if (self) {
        check_ = [CheckData sharedCheckData].currentCheck;
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
    [adjustmentsTable_ release];
    [adjustmentTextField_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.adjusmentsTable = nil;
    self.adjustmentTextField = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [adjustmentsTable_ reloadData];
}

#pragma mark - Custom Action Methods

- (IBAction)backAction:(id)sender
{
    [delegate_ adjustmentsViewControllerDidFinish:self];
}

- (IBAction)resetAction:(id)sender
{
    [check_ removeAllSplitAdjustments];
    [adjustmentsTable_ beginUpdates];
    [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]
                     withRowAnimation:UITableViewRowAnimationFade];
    [adjustmentsTable_ endUpdates];
}

- (IBAction)addAction:(id)sender
{
    NSString *stringValue = adjustmentTextField_.text;
    if (![stringValue isEqualToString:@""]) {
        NSDecimalNumber *adjustmentValue = [NSDecimalNumber decimalNumberWithString:stringValue];
        Adjustment *adjustment = [[Adjustment alloc] initWithAmount:adjustmentValue tipRate:check_.tipPercentage];
        [check_ addSplitAdjustment:adjustment];
        [adjustment release];
        
        [adjustmentsTable_ beginUpdates];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [adjustmentsTable_ reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [adjustmentsTable_ endUpdates];
        adjustmentTextField_.text = @"";
    }
    [adjustmentTextField_ resignFirstResponder];
}

#pragma mark - Private Methods

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
        
        CGRect frame = CGRectMake(0.0f, 0.0f, 280.0f, 61.0f);
        AdjustmentBalanceView *adjustmentView = [[[AdjustmentBalanceView alloc] initWithFrame:frame] autorelease];
        
        NSDecimalNumber *totalToPay = [check_ totalToPay];
        NSDecimalNumber *numberOfPeople = [check_ numberOfSplits];
        
        NSString *totalToPayStr = [totalToPay currencyString];
        NSString *numberOfPeopleStr = [check_ stringForNumberOfSplitsWithDecimalNumber:numberOfPeople];
        NSString *line1Str = [NSString stringWithFormat:@"Total to Pay: %@ (%@)", totalToPayStr, numberOfPeopleStr];
        
        NSDecimalNumber *totalBalance = [check_ totalBalanceAfterAdjustments];
        NSDecimalNumber *billAmountBalance = [check_ billAmountBalanceAfterAdjustments];
        NSDecimalNumber *tipBalance = [check_ tipBalanceAfterAdjustments];
        NSDecimalNumber *numberOfAdjustments = [check_ decimalNumberOfSplitAdjustments];
        NSDecimalNumber *numberOfPeopleLeft = [check_.numberOfSplits decimalNumberBySubtracting:numberOfAdjustments];
        
        NSString *totalBalanceStr = [totalBalance currencyString];
        NSString *billAmountBalanceStr = [billAmountBalance currencyString];
        NSString *tipBalanceStr = [tipBalance currencyString];
        NSString *line2Str = [NSString stringWithFormat:@"Balance: %@ = %@ + tip %@",
                              totalBalanceStr,
                              billAmountBalanceStr,
                              tipBalanceStr];
        
        NSDecimalNumber *balancePerPerson = [CheckHelper calculatePersonAmount:totalBalance withSplit:numberOfPeopleLeft];
        NSString *balancePerPersonStr = [balancePerPerson currencyString];
        NSString *line3Str = [NSString stringWithFormat:@"Balance Per Person: %@ (%d Left)",
                              balancePerPersonStr,
                              [numberOfPeopleLeft integerValue]];
        
        adjustmentView.line1.text = line1Str;
        adjustmentView.line2.text = line2Str;
        adjustmentView.line3.text = line3Str;
        
        cell.accessoryView = adjustmentView;
        
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Adjustment *adjustment = [check_.splitAdjustments objectAtIndex:indexPath.row];
    NSString *textStr = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                         [[adjustment total] currencyString],
                         [adjustment.amount currencyString],
                         [adjustment.tip currencyString]];
    
    NSString *detailTextStr = [NSString stringWithFormat:@"Adjustment #%d", indexPath.row + 1];
    
    cell.textLabel.text = textStr;
    cell.detailTextLabel.text = detailTextStr;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 44.0;
    if (indexPath.section == 0) {
        height = 81.0;
    }
    return height;
}

#pragma mark - UITouch Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([adjustmentTextField_ isFirstResponder]) {
        [adjustmentTextField_ resignFirstResponder];
    }
}

@end
