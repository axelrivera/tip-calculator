//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

#define kTextLabelKey @"TextLabelKey"
#define kDetailTextLabelKey @"DetailTextLabelKey"

#define kCurrencyControllerTag 200
#define kRoundingControllerTag 201

@interface SettingsViewController (Private)

+ (NSArray *)tableDataSource;

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
    
    self.title = @"Tip Calculator";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
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
    if (switchView.tag == 0) {
        settings_.sound = switchView.on;
    } else {
        settings_.shakeToClear = switchView.on;
    }
}

#pragma mark - Private Methods

+ (NSArray *)tableDataSource
{
    Settings *settings = [Settings sharedSettings];
    NSDictionary *dictionary = nil;
    NSMutableArray *sectionOne = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *sectionTwo = [[NSMutableArray alloc] initWithCapacity:2];
    
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
                  @"Tax", kTextLabelKey,
                  [settings taxString], kDetailTextLabelKey,
                  nil];
    [sectionOne addObject:dictionary];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Sound", kTextLabelKey,
                  [NSNull null], kDetailTextLabelKey,
                  nil];
    [sectionTwo addObject:dictionary];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Shake to Clear", kTextLabelKey,
                  [NSNull null], kDetailTextLabelKey,
                  nil];
    [sectionTwo addObject:dictionary];
    
    NSArray *data = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    [sectionOne release];
    [sectionTwo release];
    return data;
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
        NSString *CellIdentifier = @"SectionOneCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        
        NSDictionary *dictionary = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
        cell.detailTextLabel.text = [dictionary objectForKey:kDetailTextLabelKey];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *dictionary = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dictionary objectForKey:kTextLabelKey];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    BOOL onValue;
    if (indexPath.row == 0) {
        onValue = settings_.sound;
    } else {
        onValue = settings_.shakeToClear;
    }
    
    [switchView setOn:onValue animated:NO];
    
    cell.accessoryView = switchView;
    [switchView release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            TableSelectViewController *selectController = [[TableSelectViewController alloc] init];
            selectController.delegate = self;
            if (indexPath.row == 0) {
                selectController.selectID = kCurrencyControllerTag;
                selectController.currentIndex = [settings_ currency];
                selectController.tableData = [Settings currencyTypeArray];
                selectController.title = @"Currency";
            } else {
                selectController.selectID = kRoundingControllerTag;
                selectController.currentIndex = [settings_ rounding];
                selectController.tableData = [Settings roundingTypeArray];
                selectController.title = @"Rounding";
            }
            [self.navigationController pushViewController:selectController animated:YES];
            [selectController release];
        }
    }
}

#pragma mark UIViewController Delegates

- (void)tableSelectViewControllerDidFinish:(TableSelectViewController *)controller
{
    if (controller.selectID == kCurrencyControllerTag) {
        settings_.currency = controller.currentIndex;
    } else {
        settings_.rounding = controller.currentIndex;
    }
}

@end
