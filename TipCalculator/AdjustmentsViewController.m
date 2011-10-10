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

@interface AdjustmentsViewController (Private)

- (void)setupAdjustmentViews;

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

- (void)leftButtonAction:(id)sender
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
    
    NSComparisonResult compare = [decimalOne compare:residualAmount];
    
    NSDecimalNumber *totalPerPerson = nil;
    if (compare == NSOrderedSame) {
        totalPerPerson = roundedAmount;
    } else {
        totalPerPerson = [tmpAmount decimalNumberBySubtracting:decimalOne];
    }
    
    UIButton *currentButton = (UIButton *)sender;
    NSInteger currentIndex = currentButton.tag;
    
    AdjustmentValue *currentAdjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:currentIndex];
    AdjustmentValueView *currentView = [adjustmentViews_ objectAtIndex:currentIndex];
    
    NSLog(@"%@", roundedAmount);
}

- (void)rightButtonAction:(id)sender
{
    NSLog(@"Right Button Action");
}

- (void)sliderAction:(id)sender
{
    NSLog(@"Slider Action");
}

#pragma mark - Private Methods

- (void)setupAdjustmentViews
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSInteger totalViews = [checkData_.currentCheck.splitAdjustments count];
    NSMutableArray *views = [[NSMutableArray alloc] initWithCapacity:totalViews];
    for (NSInteger i = 0; i < totalViews; i++) {
        AdjustmentValue *adjustment = [checkData_.currentCheck.splitAdjustments objectAtIndex:i];
        NSDecimalNumber *percentage = adjustment.percentage;
        
        
        NSDecimalNumber *total = [[checkData_.currentCheck totalToPay] decimalNumberByMultiplyingBy:percentage];
        NSDecimalNumber *person = [[checkData_.currentCheck totalPerPerson] decimalNumberByMultiplyingBy:percentage];
        NSDecimalNumber *tip = [[checkData_.currentCheck totalTip] decimalNumberByMultiplyingBy:percentage];
        
        AdjustmentValueView *adjustmentView = [AdjustmentValueView adjustmentViewForCellWithTag:i];
        
        [adjustmentView.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
        [adjustmentView.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
        
        adjustmentView.slider.continuous = YES;
        adjustmentView.slider.value = [percentage floatValue];
        [adjustmentView.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        
        adjustmentView.titleLabel.text = [NSString stringWithFormat:@"%@ = %@ + tip %@",
                                          [formatter stringFromNumber:total],
                                          [formatter stringFromNumber:person],
                                          [formatter stringFromNumber:tip]];
        [views addObject:adjustmentView];
    }
    
    self.adjustmentViews = views;
    [formatter release];
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
    return 70.0;
}

@end
