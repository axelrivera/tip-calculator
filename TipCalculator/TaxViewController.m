//
//  TaxViewController.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/4/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "TaxViewController.h"
#import "ControllerConstants.h"

#define kMaxNumberOfIntegersInRange 25
#define kMaxNumberOfDecimalsInRange 10

static NSArray *integerRange_;
static NSArray *decimalRange_;

@interface TaxViewController (Private)

+ (NSArray *)integerRange;
+ (NSArray *)decimalRange;

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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [delegate_ taxViewControllerDidFinish:self];
}

#pragma mark - Custom Actions

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

#pragma mark - Private Class Methods

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
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 200.0, 30.0)];
        textField.font = [UIFont systemFontOfSize:16.0];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.placeholder = @"Enter Tax Rate";
        textField.textAlignment = UITextAlignmentRight;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.inputView = pickerView_;
        textField.delegate = self;
        accessoryView = textField;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
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
        case 4:
            rows = [[TaxViewController decimalRange] count];
            break;
        case 5:
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
        case 4:
            title = [[TaxViewController decimalRange] objectAtIndex:row];
            break;
        case 5:
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
        case 4:
            width = 44.0;
            break;
        case 5:
            width = 40.0;
            break;
        default:
            break;
    }
    return width;
}

@end
