//
//  AdjustmentsViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentsViewController.h"
#import "CheckData.h"
#import "AdjustmentValue.h"
#import "AdjustmentValueView.h"

@implementation AdjustmentsViewController

@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize totalLabel = totalLabel_;
@synthesize contentViewController = contentViewController_;

- (id)init
{
    self = [super initWithNibName:@"AdjustmentsViewController" bundle:nil];
    if (self) {
        checkData_ = [CheckData sharedCheckData];
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
    [adjustmentsTable_ release];
    [totalLabel_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    adjustmentsTable_.backgroundColor = [UIColor clearColor];
    adjustmentsTable_.opaque = NO;
    adjustmentsTable_.backgroundView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.adjusmentsTable = nil;
    self.totalLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    totalLabel_.text = [NSString stringWithFormat:@"Total: %@", [checkData_.currentCheck stringForTotalToPay]];
    [adjustmentsTable_ reloadData];
}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [checkData_.currentCheck.splitAdjustments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([checkData_.currentCheck.splitAdjustments count] <= 1) {
        NSString *CellIdentifier = @"DefaultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"Adjust cell when splitting check";
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AdjustmentValueView *adjustmentView = [[[AdjustmentValueView alloc] init] autorelease];
    cell.accessoryView = adjustmentView;
        
    AdjustmentValue *adjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:indexPath.row];
    NSDecimal decimalValue = [adjustment.percentage decimalValue];
    NSDecimalNumber *percentage = [NSDecimalNumber decimalNumberWithDecimal:decimalValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDecimalNumber *total = [[checkData_.currentCheck totalToPay] decimalNumberByMultiplyingBy:percentage];
    NSDecimalNumber *person = [[checkData_.currentCheck totalPerPerson] decimalNumberByMultiplyingBy:percentage];
    NSDecimalNumber *tip = [[checkData_.currentCheck totalTip] decimalNumberByMultiplyingBy:percentage];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ = %@ + %@",
                                 [formatter stringFromNumber:total],
                                 [formatter stringFromNumber:person],
                                 [formatter stringFromNumber:tip]];
    
    return cell;
}

@end
