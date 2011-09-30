//
//  SummaryViewController.m
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SummaryViewController.h"

@implementation SummaryViewController

@synthesize summaryTable = summaryTable_;
@synthesize infoButton = infoButton_;

- (id)init
{
    self = [super initWithNibName:@"SummaryViewController" bundle:nil];
    if (self) {
        // Custom initialization
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
    [infoButton_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    summaryTable_.backgroundColor = [UIColor clearColor];
    summaryTable_.opaque = NO;
    summaryTable_.backgroundView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.summaryTable = nil;
    self.infoButton = nil;
}

#pragma mark - Custom Methods

- (IBAction)infoButtonAction:(id)sender
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	//navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[settingsViewController release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [controller dismissModalViewControllerAnimated:YES];
}


#pragma mark - TableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == 0) {
        rows = 3;
    } else {
        rows = 3;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = @"This is a test";
    
    return cell;
}

@end
