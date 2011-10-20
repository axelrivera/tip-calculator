//
//  AdjustmentsViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentsViewController.h"
#import "CheckData.h"
#import "Adjustment.h"
#import "AdjustmentValueView.h"

@interface AdjustmentsViewController (Private)

- (void)setupAdjustmentViews;
- (void)subtractOneToIndex:(NSInteger)index;
- (void)addOneToIndex:(NSInteger)index;

@end

@implementation AdjustmentsViewController

@synthesize delegate = delegate_;
@synthesize adjusmentsTable = adjustmentsTable_;
@synthesize totalLabel = totalLabel_;
@synthesize adjustmentViews = adjustmentViews_;

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
    [adjustmentViews_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setWantsFullScreenLayout:YES];
    adjustmentsTable_.allowsSelection = NO;
    [self setupAdjustmentViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.adjusmentsTable = nil;
    self.totalLabel = nil;
    self.adjustmentViews = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    totalLabel_.text = [NSString stringWithFormat:@"Total: %@", [checkData_.currentCheck stringForTotalToPay]];
    [adjustmentsTable_ reloadData];
}

#pragma mark - Custom Action Methods

- (IBAction)backAction:(id)sender
{
    [delegate_ adjustmentsViewControllerDidFinish:self];
}

- (void)stepperAction:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    NSInteger tag = segmentedControl.tag;
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [self subtractOneToIndex:tag];
    } else {
        [self addOneToIndex:tag];
    }
}

#pragma mark - Private Methods

- (void)setupAdjustmentViews
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSInteger totalViews = [checkData_.currentCheck.splitAdjustments count];
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:totalViews];
    for (NSInteger i = 0; i < totalViews; i++) {
        Adjustment *adjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:i];
        
        NSDecimalNumber *total = adjustment.adjustmentValue;
        NSDecimalNumber *tip = [[checkData_.currentCheck totalTip] decimalNumberByDividingBy:checkData_.currentCheck.numberOfSplits];
        NSDecimalNumber *person = [total decimalNumberBySubtracting:tip];
        
        AdjustmentValueView *adjustmentView = [AdjustmentValueView adjustmentViewForCellWithTag:i];
        
        adjustmentView.titleLabel.text = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                                          [formatter stringFromNumber:total],
                                          [formatter stringFromNumber:person],
                                          [formatter stringFromNumber:tip]];
        
        [adjustmentView.segmentedControl addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
        
        [views addObject:adjustmentView];
    }
    
    self.adjustmentViews = views;
    [formatter release];
}

- (void)subtractOneToIndex:(NSInteger)index
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *tmpAmount = [checkData_.currentCheck totalPerPerson];
    NSDecimalNumber *roundedAmount = [[tmpAmount decimalNumberByRoundingAccordingToBehavior:behavior] retain];
    NSDecimalNumber *residualAmount = [tmpAmount decimalNumberBySubtracting:roundedAmount];
    
    NSDecimalNumber *decimalOne = [NSDecimalNumber one];
    
    NSDecimalNumber *totalPerPerson = nil;
    
    NSComparisonResult compare = [decimalOne compare:residualAmount];
    if (compare == NSOrderedSame) {
        totalPerPerson = roundedAmount;
    } else {
        totalPerPerson = [tmpAmount decimalNumberBySubtracting:decimalOne];
    }
    
    Adjustment *currentAdjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:index];
    AdjustmentValueView *currentView = [adjustmentViews_ objectAtIndex:index];
    
    NSLog(@"%@", roundedAmount);
}

- (void)addOneToIndex:(NSInteger)index
{
    NSLog(@"Right Button Action");
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
    
    cell.accessoryView = [adjustmentViews_ objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

@end
