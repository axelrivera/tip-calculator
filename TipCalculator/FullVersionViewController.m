//
//  FullVersionViewController.m
//  TipCalculator
//
//  Created by Axel Rivera on 1/17/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import "FullVersionViewController.h"
#import "LocalyticsSession.h"
#import "Constants.h"

@implementation FullVersionViewController

@synthesize downloadButton = downloadButton_;

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
	[downloadButton_ release];
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
	UIImage *greenImage = [UIImage imageNamed:@"button_green_default.png"];
	UIImage *blueImage = [UIImage imageNamed:@"button_blue_default.png"];
	
	UIImage *greenStretchableImage = nil;
	UIImage *blueStretchableImage = nil;
	
	if ([greenImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
		greenStretchableImage = [greenImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0)];
	} else {
		greenStretchableImage = [greenImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:37.0];
	}
	
	if ([blueImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
		blueStretchableImage = [blueImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0)];
	} else {
		blueStretchableImage = [blueImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:37.0];
	}
	
	[self.downloadButton setBackgroundImage:greenStretchableImage forState:UIControlStateNormal];
	[self.downloadButton setBackgroundImage:blueStretchableImage forState:UIControlStateHighlighted];
	[self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.downloadButton setTitle:@"Download Now" forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.downloadButton = nil;
}

#pragma mark - Action Methods

- (IBAction)dismissAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)downloadAction:(id)sender
{
	// Log Analytics Event
	[[LocalyticsSession sharedLocalyticsSession] tagEvent:ANALYTICS_DOWNLOAD_FULL_VERSION_EVENT];
	NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=487270554&mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

@end
