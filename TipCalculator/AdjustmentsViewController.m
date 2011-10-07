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
    adjustmentsTable_.allowsSelection = NO;
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

#pragma mark - Custom Actions

- (void)leftButtonAction:(id)sender
{
    NSLog(@"Left Button Action");
}

- (void)rightButtonAction:(id)sender
{
    NSLog(@"Right Button Action");
}

- (void)sliderAction:(id)sender
{
    NSLog(@"Slider Action");
}

#pragma mark - UITableView Datasource Methods

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
    
    AdjustmentValue *adjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:indexPath.row];
    NSDecimal decimalValue = [adjustment.percentage decimalValue];
    NSDecimalNumber *percentage = [NSDecimalNumber decimalNumberWithDecimal:decimalValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDecimalNumber *total = [[checkData_.currentCheck totalToPay] decimalNumberByMultiplyingBy:percentage];
    NSDecimalNumber *person = [[checkData_.currentCheck totalPerPerson] decimalNumberByMultiplyingBy:percentage];
    NSDecimalNumber *tip = [[checkData_.currentCheck totalTip] decimalNumberByMultiplyingBy:percentage];
    
    AdjustmentValueView *adjustmentView = [AdjustmentValueView adjustmentViewForCellWithTag:indexPath.row];
    
    [adjustmentView.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
    [adjustmentView.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
    
    adjustmentView.slider.continuous = YES;
    adjustmentView.slider.value = [percentage floatValue];
    [adjustmentView.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    adjustmentView.titleLabel.text = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                                      [formatter stringFromNumber:total],
                                      [formatter stringFromNumber:person],
                                      [formatter stringFromNumber:tip]];
    
    cell.accessoryView = adjustmentView;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

@end
