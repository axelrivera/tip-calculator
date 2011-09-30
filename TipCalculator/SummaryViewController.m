//
//  SummaryViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SummaryViewController.h"
#import "Check.h"

#define kTextLabelKey @"TextLabelKey"
#define kDetailTextLabelKey @"DetailTextLabelKey"

@interface SummaryViewController (Private)

- (void)createPicker;

- (NSArray *)checkInputArray;
- (NSArray *)checkSummaryArray;

@end

@implementation SummaryViewController

@synthesize summaryTable = summaryTable_;
@synthesize summaryDataSource = summaryDataSource_;
@synthesize pickerView = pickerView_;
@synthesize splitDataSource = splitDataSource_;
@synthesize tipPercentDataSource = tipPercentDataSource_;
@synthesize currentPickerDataSource = currentPickerDataSource_;
@synthesize pickerType = pickerType_;
@synthesize currentCheck = currentCheck_;
@synthesize contentViewController = contentViewController_;

- (id)init
{
    self = [super initWithNibName:@"SummaryViewController" bundle:nil];
    if (self) {
        currentCheck_ = [[Check alloc] init];
        
        NSMutableArray *people = [[NSMutableArray alloc] initWithCapacity:50];
        for (NSInteger i = 1; i <= 50; i++) {
            NSString *string = [[[NSString alloc] initWithFormat:@"%d People", i] autorelease];
            [people addObject:string];
        }
        self.splitDataSource = people;
        [people release];
        
        NSMutableArray *tips = [[NSMutableArray alloc] initWithCapacity:51];
        for (NSInteger i = 0; i <= 50; i++) {
            NSString *string = [[[NSString alloc] initWithFormat:@"%f %", i * 0.01] autorelease];
            [tips addObject:string];
        }
        self.tipPercentDataSource = tips;
        [tips release];
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
    [summaryTable_ release];
    [summaryDataSource_ release];
    [pickerView_ release];
    [splitDataSource_ release];
    [tipPercentDataSource_ release];
    [currentCheck_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    summaryTable_.allowsSelection = NO;
    summaryTable_.backgroundColor = [UIColor clearColor];
    summaryTable_.opaque = NO;
    summaryTable_.backgroundView = nil;
    
    self.summaryDataSource = [NSArray arrayWithObjects:
                              [self checkInputArray],
                              [self checkSummaryArray],
                              nil];
    
    [self createPicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.summaryTable = nil;
    self.pickerView = nil;
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [summaryDataSource_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[summaryDataSource_ objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *dictionary = [[summaryDataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0 && indexPath.row <= 1) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
    cell.detailTextLabel.text = [dictionary objectForKey:kDetailTextLabelKey];
        
    return cell;
}

#pragma mark - UITableView Delegate Methods

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
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
    return [currentPickerDataSource_ objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300.00;
}

#pragma mark - Private Methods

- (void)createPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    self.pickerView = pickerView;
    [pickerView release];
}

- (NSArray *)checkInputArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    
    NSDictionary *dictionary = nil;
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Split Check", kTextLabelKey,
                  [currentCheck_ stringForNumberOfSplits], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Tip Percentage", kTextLabelKey,
                  [currentCheck_ stringForTipPercentage], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Bill Total", kTextLabelKey,
                  [currentCheck_ stringForCheckAmount], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    return array;
}

- (NSArray *)checkSummaryArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    
    NSDictionary *dictionary = nil;
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Total Tip", kTextLabelKey,
                  [currentCheck_ stringForTotalTip], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Total to Pay", kTextLabelKey,
                  [currentCheck_ stringForTotalToPay], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Total Per Person", kTextLabelKey,
                  [currentCheck_ stringForTotalPerPerson], kDetailTextLabelKey,
                  nil];
    
    [array addObject:dictionary];
    
    return array;
}

@end
