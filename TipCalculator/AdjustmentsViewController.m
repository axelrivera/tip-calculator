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

@interface AdjustmentsViewController (Private)

@end

@implementation AdjustmentsViewController

@synthesize delegate = delegate_;
@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize adjustmentTextField = adjustmentTextField_;
@synthesize totalLabel = totalLabel_;

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
    [totalLabel_ release];
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
    self.totalLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    totalLabel_.text = [NSString stringWithFormat:@"Total: %@", [[check_ totalToPay] currencyString]];
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
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        NSDecimalNumber *totalBalance = [check_ totalBalanceAfterAdjustments];
        NSDecimalNumber *billAmountBalance = [check_ billAmountBalanceAfterAdjustments];
        NSDecimalNumber *tipBalance = [check_ tipBalanceAfterAdjustments];
        NSDecimalNumber *numberOfAdjustments = [check_ decimalNumberOfSplitAdjustments];
        NSDecimalNumber *numberOfPeopleLeft = [check_.numberOfSplits decimalNumberBySubtracting:numberOfAdjustments];
        
        NSString *totalBalanceStr = [totalBalance currencyString];
        NSString *billAmountBalanceStr = [billAmountBalance currencyString];
        NSString *tipBalanceStr = [tipBalance currencyString];
        NSString *textStr = [NSString stringWithFormat:@"Balance: %@ = %@ + tip %@",
                             totalBalanceStr,
                             billAmountBalanceStr,
                             tipBalanceStr];
        
        NSDecimalNumber *balancePerPerson = [CheckHelper calculatePersonAmount:totalBalance withSplit:numberOfPeopleLeft];
        NSString *balancePerPersonStr = [balancePerPerson currencyString];
        NSString *detailTextStr = [NSString stringWithFormat:@"Per Person: %@ (%d People Left)",
                                   balancePerPersonStr,
                                   [numberOfPeopleLeft integerValue]];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.textLabel.text = textStr;
        cell.detailTextLabel.text = detailTextStr;
        
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
    return 44.0;
}

#pragma mark - UITouch Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([adjustmentTextField_ isFirstResponder]) {
        [adjustmentTextField_ resignFirstResponder];
    }
}

@end
