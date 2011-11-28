//
//  AdjustmentViewCell.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/28/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "AdjustmentViewCell.h"

@implementation AdjustmentViewCell

@synthesize adjustmentView = adjustmentView_;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[adjustmentView_ release];
	[super dealloc];
}

- (void)setAdjustmentView:(AdjustmentView *)adjustmentView
{
	[adjustmentView_ removeFromSuperview];
	[adjustmentView_ autorelease];
	
	CGRect avFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	adjustmentView_ = [adjustmentView retain];
	adjustmentView_.frame = avFrame;
	adjustmentView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:adjustmentView_];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)redisplay
{
	[self.adjustmentView setNeedsDisplay];
}


@end
