//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ControllerConstants.h"

@interface SettingsViewController (Private)

+ (NSArray *)tableDataSource;
- (void)goToWebsite:(id)sender;

@end

@implementation SettingsViewController

@synthesize delegate = delegate_;

- (id)init
{
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        settings_ = [Settings sharedSettings];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Friendly Tip Calculator";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Custom Action Methods

- (void)doneAction:(id)sender
{
    [delegate_ settingsViewControllerDidFinish:self];
}

- (void)switchAction:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    switch (switchView.tag) {
		case kSettingsControllerShakeToClearTag:
            settings_.shakeToClear = switchView.on;
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods

+ (NSArray *)tableDataSource
{
    Settings *settings = [Settings sharedSettings];
    NSDictionary *dictionary = nil;
    NSMutableArray *sectionOne = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *sectionTwo = [[NSMutableArray alloc] initWithCapacity:2];
	NSMutableArray *sectionThree = [[NSMutableArray alloc] initWithCapacity:2];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Currency", kTextLabelKey,
                  [settings currencyString], kDetailTextLabelKey,
                  nil];
    [sectionOne addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Rounding", kTextLabelKey,
                  [settings roundingString], kDetailTextLabelKey,
                  nil];
    [sectionOne addObject:dictionary];
	dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"Confirm Adjustment", kTextLabelKey,
				  [settings adjustmentConfirmationString], kDetailTextLabelKey,
				  nil];
	[sectionOne addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Tip On Tax", kTextLabelKey,
                  [settings tipOnTaxString], kDetailTextLabelKey,
                  nil];
    [sectionOne addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Tax Rate", kTextLabelKey,
                  [settings taxString], kDetailTextLabelKey,
                  nil];
    [sectionOne addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Shake to Clear", kTextLabelKey,
                  [NSNull null], kDetailTextLabelKey,
                  nil];
    [sectionTwo addObject:dictionary];
	
	dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"Rivera Labs Website", kTextLabelKey,
				  [NSNull null], kDetailTextLabelKey,
				  nil];
	[sectionThree addObject:dictionary];
    
    NSArray *data = [[[NSArray alloc] initWithObjects:sectionOne, sectionTwo, sectionThree, nil] autorelease];
    [sectionOne release];
    [sectionTwo release];
	[sectionThree release];
    return data;
}

- (void)goToWebsite:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://riveralabs.com"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[SettingsViewController tableDataSource] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[SettingsViewController tableDataSource] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data = [SettingsViewController tableDataSource];
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"DefaultCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        
        NSDictionary *dictionary = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
        cell.detailTextLabel.text = [dictionary objectForKey:kDetailTextLabelKey];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.section == 1) {
    
		NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		NSDictionary *dictionary = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
		cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
		
		UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
		[switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
		
		BOOL onValue = settings_.shakeToClear;
		NSInteger tag = kSettingsControllerShakeToClearTag;
		
		[switchView setOn:onValue animated:NO];
		switchView.tag = tag;
		
		cell.accessoryView = switchView;
		[switchView release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		return cell;
	}
	
	NSString *CellIdentifier = @"OwnerCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *dictionary = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *title = nil;
	if (section == 2) {
		title = [NSString stringWithFormat:
				 @"Friendly Tip Calculator %@\n"
				 @"Copyright © 2011; Rivera Labs.",
				 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	}
	return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row >= 0 && indexPath.row <= 3) {
            TableSelectViewController *selectController = [[TableSelectViewController alloc] init];
            selectController.delegate = self;
            if (indexPath.row == 0) {
                selectController.selectID = kCurrencyControllerTag;
                selectController.currentIndex = settings_.currency;
                selectController.tableData = [Settings currencyTypeArray];
                selectController.title = @"Currency";
            } else if (indexPath.row == 1) {
                selectController.selectID = kRoundingControllerTag;
                selectController.currentIndex = settings_.rounding;
                selectController.tableData = [Settings roundingTypeArray];
                selectController.title = @"Rounding";
            } else if (indexPath.row == 2) {
				selectController.selectID = kAdjustmentConfirmationControllerTag;
				selectController.currentIndex = settings_.adjustmentConfirmation;
				selectController.tableData = [NSArray arrayWithObjects:@"No", @"Yes", nil];
				selectController.tableFooterTitle = @"Answer \"Yes\" to show a confirmation screen when adding split adjustments. "
													"You will be shown the tax, tip and total before saving every "
													"split adjustment.";
				selectController.title = @"Adjustment";
			} else {
                selectController.selectID = kTipOnTaxControllerTag;
                selectController.currentIndex = (NSInteger)settings_.tipOnTax;
                selectController.tableData = [NSArray arrayWithObjects:@"No", @"Yes", nil];
                selectController.tableFooterTitle = @"Answer \"Yes\" to tip on the total amount including taxes. "
													"You can set your local tax rate in the previous screen.";
                selectController.title = @"Tip On Tax";
            }
            [self.navigationController pushViewController:selectController animated:YES];
            [selectController release];
        } else {
            TaxViewController *taxController = [[TaxViewController alloc] init];
            taxController.delegate = self;
            taxController.taxRate = settings_.taxRate;
            taxController.title = @"Tax";
            [self.navigationController pushViewController:taxController animated:YES];
            [taxController release];
        }
    } else if (indexPath.section == 2) {
		[self performSelector:@selector(goToWebsite:)];
	}
}

#pragma mark UIViewController Delegates

- (void)tableSelectViewControllerDidFinish:(TableSelectViewController *)controller
{
    if (controller.selectID == kCurrencyControllerTag) {
        settings_.currency = controller.currentIndex;
    } else if (controller.selectID == kRoundingControllerTag) {
        settings_.rounding = controller.currentIndex;
    }  else if (controller.selectID == kAdjustmentConfirmationControllerTag) {
		settings_.adjustmentConfirmation = (BOOL)controller.currentIndex;
	} else {
        settings_.tipOnTax = (BOOL)controller.currentIndex;
    }
}

- (void)taxViewControllerDidFinish:(TaxViewController *)controller
{
    settings_.taxRate = controller.taxRate;
}

@end
