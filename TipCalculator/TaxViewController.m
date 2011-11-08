//
//  TaxViewController.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/4/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "TaxViewController.h"
#import "ControllerConstants.h"
#import "NSDecimalNumber+Check.h"
#import "RLInputLabel.h"

#define kMaxNumberOfIntegersInRange 25
#define kMaxNumberOfDecimalsInRange 10

static NSArray *integerRange_;
static NSArray *decimalRange_;

@interface TaxViewController (Private)

+ (NSArray *)integerRange;
+ (NSArray *)decimalRange;

- (void)setTaxRateWithString:(NSString *)string;
- (NSString *)stringFromPickerView:(UIPickerView *)pickerView;

- (void)setPickerViewWithDecimalNumber:(NSDecimalNumber *)decimalNumber animated:(BOOL)animated;
- (void)loadPickerView;
- (void)dismissPickerView;

@end

@implementation TaxViewController

@synthesize delegate = delegate_;
@synthesize pickerView = pickerView_;
@synthesize tipOnTax = tipOnTax_;
@synthesize taxOnAdjustments = taxOnAdjustments_;
@synthesize taxRate = taxRate_;

- (id)init
{
    self = [super initWithNibName:@"TaxViewController" bundle:nil];
    if (self) {
        self.tipOnTax = NO;
        self.taxOnAdjustments = NO;
        self.taxRate = [NSDecimalNumber zero];
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
    delegate_ = nil;
    [pickerView_ release];
    [taxRate_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pickerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self setPickerViewWithDecimalNumber:taxRate_ animated:NO];
    [self loadPickerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissPickerView];
    [delegate_ taxViewControllerDidFinish:self];
}

#pragma mark -
#pragma mark Custom Actions

- (void)switchAction:(id)sender
{
    NSLog(@"Switch Action");
    UISwitch *switchView = (UISwitch *)sender;
    switch (switchView.tag) {
        case kTaxControllerTipOnTaxTag:
            self.tipOnTax = switchView.on;
            break;
        case kTaxControllerTaxOnAdjustmentsTag:
            self.taxOnAdjustments = switchView.on;
            break;
        default:
            break;
    }
}

#pragma mark Private Class Methods

+ (NSArray *)integerRange
{
    if (integerRange_ == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:kMaxNumberOfIntegersInRange];
        for (NSInteger i = 0; i < kMaxNumberOfIntegersInRange; i++) {
            [array addObject:[[NSNumber numberWithInteger:i] stringValue]];
        }
        integerRange_ = [[NSArray alloc] initWithArray:array];
        [array release];
    }
    return integerRange_;
}

+ (NSArray *)decimalRange
{
    if (decimalRange_ == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:kMaxNumberOfDecimalsInRange];
        for (NSInteger i = 0; i < kMaxNumberOfDecimalsInRange; i++) {
            [array addObject:[[NSNumber numberWithInteger:i] stringValue]];
        }
        decimalRange_ = [[NSArray alloc] initWithArray:array];
        [array release];
    }
    return decimalRange_;    
}

#pragma mark Private Methods

- (void)setTaxRateWithString:(NSString *)string
{
    self.taxRate = [NSDecimalNumber decimalNumberWithString:string];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    RLInputLabel *inputLabel = (RLInputLabel *)[cell viewWithTag:kTaxControllerTaxRateTag];
    NSLog(@"Tax Rate: %@", taxRate_);
    inputLabel.text = [taxRate_ taxString];
}

- (NSString *)stringFromPickerView:(UIPickerView *)pickerView
{
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < [pickerView numberOfComponents]; i++) {
        if (i == 0) {
            [string appendString:[[TaxViewController integerRange] objectAtIndex:[pickerView selectedRowInComponent:i]]];
        } else if (i == 1) {
            [string appendString:@"."];
        } else if (i >= 2 && i <= 3) {
            [string appendString:[[TaxViewController decimalRange] objectAtIndex:[pickerView selectedRowInComponent:i]]];
        }
    }
    return string;
}

- (void)setPickerViewWithDecimalNumber:(NSDecimalNumber *)decimalNumber animated:(BOOL)animated
{
    NSString *taxStr = [decimalNumber taxString];
    NSArray *components = [taxStr componentsSeparatedByString:@"."];
    NSString *integerStr = [components objectAtIndex:0];
    NSString *decimalStr = [components objectAtIndex:1];
    [pickerView_ selectRow:[integerStr integerValue] inComponent:0 animated:animated];
    [pickerView_ selectRow:[[decimalStr substringWithRange:NSMakeRange(0, 1)] integerValue] inComponent:2 animated:animated];
    [pickerView_ selectRow:[[decimalStr substringWithRange:NSMakeRange(1, 1)] integerValue] inComponent:3 animated:animated];
}

- (void)loadPickerView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    RLInputLabel *inputLabel = (RLInputLabel *)[cell viewWithTag:kTaxControllerTaxRateTag];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [inputLabel becomeFirstResponder];
}

- (void)dismissPickerView
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        RLInputLabel *inputLabel = (RLInputLabel *)[cell viewWithTag:kTaxControllerTaxRateTag];
        [inputLabel resignFirstResponder];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *textLabelStr = nil;
    UIView *accessoryView = nil;
    NSInteger tag;
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        BOOL onValue;
        if (indexPath.row == 0) {
            textLabelStr = @"Tip On Tax";
            onValue = tipOnTax_;
            tag = kTaxControllerTipOnTaxTag;
        } else {
            textLabelStr = @"Tax Adjsutments";
            onValue = taxOnAdjustments_;
            tag = kTaxControllerTaxOnAdjustmentsTag;
        }
        [switchView setOn:onValue animated:NO];
        accessoryView = switchView;
    } else {
        textLabelStr = @"Tax Rate";
        tag = kTaxControllerTaxRateTag;
        RLInputLabel *inputLabel = [[RLInputLabel alloc] initWithFrame:CGRectMake(0.0, 7.0, 200.0, 30.0)];
        inputLabel.font = [UIFont systemFontOfSize:17.0];
        inputLabel.adjustsFontSizeToFitWidth = YES;
        inputLabel.textAlignment = UITextAlignmentRight;
        inputLabel.inputView = pickerView_;
        inputLabel.textColor = [UIColor darkGrayColor];
        inputLabel.backgroundColor = [UIColor clearColor];
        inputLabel.highlightedTextColor = [UIColor whiteColor];
        inputLabel.text = [taxRate_ taxString];
        accessoryView = inputLabel;
    }
    
    accessoryView.tag = tag;
    
    cell.textLabel.text = textLabelStr;
    cell.accessoryView = accessoryView;
    
    if (accessoryView) {
        [accessoryView release];
    }
    
    return cell;
}

#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = [[TaxViewController integerRange] count];
            break;
        case 1:
            rows = 1;
            break;
        case 2:
        case 3:
            rows = [[TaxViewController decimalRange] count];
            break;
        case 4:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    switch (component) {
        case 0:
            title = [[TaxViewController integerRange] objectAtIndex:row];
            break;
        case 1:
            title = @".";
            break;
        case 2:
        case 3:
            title = [[TaxViewController decimalRange] objectAtIndex:row];
            break;
        case 4:
            title = @"%";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.0;
    switch (component) {
        case 0:
            width = 48.0;
            break;
        case 1:
            width = 22.0;
            break;
        case 2:
        case 3:
            width = 48.0;
            break;
        case 4:
            width = 40.0;
            break;
        default:
            break;
    }
    return width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setTaxRateWithString:[self stringFromPickerView:pickerView]];
}

@end
