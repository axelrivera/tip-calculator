//
//  TaxOptionsViewController.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/9/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "TaxOptionsViewController.h"
#import "ControllerConstants.h"

@implementation TaxOptionsViewController

@synthesize delegate = delegate_;
@synthesize tipOnTaxIndex = tipOnTaxIndex_;
@synthesize taxOnAdjustmentsIndex = taxOnAdjustmentsIndex_;

- (id)init
{
    self = [super initWithNibName:@"TaxOptionsViewController" bundle:nil];
    if (self) {
        tipOnTaxIndex_ = 0;
        taxOnAdjustmentsIndex_ = 0;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [delegate_ taxOptionsViewControllerDidFinish:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *textLabelStr = nil;
    
    if (indexPath.row == 0) {
        textLabelStr = @"No";
    } else {
        textLabelStr = @"Yes";
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ((indexPath.section == 0 && indexPath.row == tipOnTaxIndex_) ||
        (indexPath.section == 1 && indexPath.row == taxOnAdjustmentsIndex_)) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.textLabel.text = textLabelStr;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger localIndex;
    
    if (indexPath.section == 0) {
        localIndex = tipOnTaxIndex_;
    } else {
        localIndex = taxOnAdjustmentsIndex_;
    }
    
	if (localIndex == indexPath.row) {
		return;
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	if (newCell.accessoryType == UITableViewCellAccessoryNone) {
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		localIndex = indexPath.row;
	}
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
		oldCell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    if (indexPath.section == 0) {
        tipOnTaxIndex_ = localIndex;
    } else {
        taxOnAdjustmentsIndex_ = localIndex;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Tip On Tax";
    } else {
        title = @"Tax Split Adjustments";
    }
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Answer \"Yes\" to tip on the total amount including taxes.";
    } else {
        title = @"Answer \"Yes\" to add taxes automatically in split adjustments.";
    }
    return title;
}

@end
