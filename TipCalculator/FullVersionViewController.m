//
//  FullVersionViewController.m
//  TipCalculator
//
//  Created by Axel Rivera on 1/17/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "FullVersionViewController.h"

@implementation FullVersionViewController

@synthesize imageView = imageView_;

- (id)init
{
	self = [super initWithNibName:@"FullVersionViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[imageView_ release];
	[super dealloc];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageView = nil;
}

#pragma mark - Action Methods

- (IBAction)dismissAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
