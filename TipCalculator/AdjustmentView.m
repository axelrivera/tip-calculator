//
//  AdjustmentView.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/28/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "AdjustmentView.h"
#import "UIColor+TipCalculator.h"

@implementation AdjustmentView

@synthesize textLabel1 = textLabel1_;
@synthesize textLabel2 = textLabel2_;
@synthesize detailTextLabel1 = detailTextLabel1_;
@synthesize detailTextLabel2 = detailTextLabel2_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
        textLabel1_ = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel1_.backgroundColor = [UIColor clearColor];
		textLabel1_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
		textLabel1_.textAlignment = UITextAlignmentLeft;
		[self addSubview:textLabel1_];
		
		detailTextLabel1_ = [[UILabel alloc] initWithFrame:CGRectZero];
		detailTextLabel1_.backgroundColor = [UIColor clearColor];
		detailTextLabel1_.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:16.0];
		detailTextLabel1_.textColor = [UIColor colorWithWhite:1.0 alpha:0.95];
		detailTextLabel1_.textAlignment = UITextAlignmentRight;
		[self addSubview:detailTextLabel1_];
		
		textLabel2_ = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel2_.backgroundColor = [UIColor clearColor];
		textLabel2_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
		textLabel2_.textAlignment = UITextAlignmentLeft;
		[self addSubview:textLabel2_];
		
		detailTextLabel2_ = [[UILabel alloc] initWithFrame:CGRectZero];
		detailTextLabel2_.backgroundColor = [UIColor clearColor];
		detailTextLabel2_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
		detailTextLabel2_.textColor = [UIColor colorWithWhite:1.0 alpha:0.60];
		detailTextLabel2_.textAlignment = UITextAlignmentRight;
		[self addSubview:detailTextLabel2_];
		
		[self setRowTextColor];
    }
    return self;
}

- (void)dealloc
{
	[textLabel1_ release];
	[textLabel2_ release];
	[detailTextLabel1_ release];
	[detailTextLabel2_ release];
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
#define kVerticalPadding 10.0f
#define kHorizontalPadding 10.0f
#define kLabelHeight 20.0f
#define kLabelOffset 5.0f
#define kTextLabel1Width 120.0f
#define kTextLabel2Width 100.0f
	
	CGSize contentSize = self.frame.size;
	
	CGFloat detailLabel1Width = contentSize.width - (kHorizontalPadding + kLabelOffset + kTextLabel1Width + kHorizontalPadding);
	textLabel1_.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, kTextLabel1Width, kLabelHeight);
	
	detailTextLabel1_.frame = CGRectMake(kHorizontalPadding + kTextLabel1Width + kLabelOffset,
										 kVerticalPadding,
										 detailLabel1Width,
										 kLabelHeight);
	
	CGFloat detailLabel2Width = contentSize.width - (kHorizontalPadding + kLabelOffset + kTextLabel2Width + kHorizontalPadding);
	textLabel2_.frame = CGRectMake(kHorizontalPadding,
								   kVerticalPadding + kLabelHeight + kLabelOffset,
								   kTextLabel2Width,
								   kLabelHeight);
	
	detailTextLabel2_.frame = CGRectMake(kHorizontalPadding + kTextLabel2Width + kLabelOffset,
										 kVerticalPadding + kLabelHeight + kLabelOffset,
										 detailLabel2Width,
										 kLabelHeight);
}

#pragma mark - Custom Methods

- (void)setRowTextColor
{
	textLabel1_.textColor = [UIColor yellowChalkColor];
	textLabel2_.textColor = [UIColor yellowChalkColor];
}

- (void)setSummaryTextColor
{
	textLabel1_.textColor = [UIColor brightYellowChalkColor];
	textLabel2_.textColor = [UIColor brightYellowChalkColor];
}

@end
