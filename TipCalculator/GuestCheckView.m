//
//  GuestCheckView.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/23/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "GuestCheckView.h"

@implementation GuestCheckView

@synthesize totalTipLabel = totalTipLabel_;
@synthesize totalToPayLabel = totalToPayLabel_;
@synthesize totalPerPersonLabel = totalPerPersonLabel_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guest_check_background.png"]];
        
        UIFont *titleFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:16.0];
        UIFont *detailFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:14.0];
        UIColor *labelColor = [UIColor whiteColor];
        
        totalTipTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalTipTitleLabel_.backgroundColor = [UIColor clearColor];
        totalTipTitleLabel_.font = titleFont;
        totalTipTitleLabel_.textColor = labelColor;
        totalTipTitleLabel_.text = @"Total Tip";
        totalTipTitleLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:totalTipTitleLabel_];
        
        totalToPayTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalToPayTitleLabel_.backgroundColor = [UIColor clearColor];
        totalToPayTitleLabel_.font = titleFont;
        totalToPayTitleLabel_.textColor = labelColor;
        totalToPayTitleLabel_.text = @"Total to Pay";
        totalToPayTitleLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:totalToPayTitleLabel_];
        
        totalPerPersonTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalPerPersonTitleLabel_.backgroundColor = [UIColor clearColor];
        totalPerPersonTitleLabel_.font = titleFont;
        totalPerPersonTitleLabel_.textColor = labelColor;
        totalPerPersonTitleLabel_.text = @"Total per Person";
        totalPerPersonTitleLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:totalPerPersonTitleLabel_];
        
        totalTipLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalTipLabel_.backgroundColor = [UIColor clearColor];
        totalTipLabel_.font = detailFont;
        totalTipLabel_.textColor = labelColor;
        totalTipLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:totalTipLabel_];
        
        totalToPayLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalToPayLabel_.backgroundColor = [UIColor clearColor];
        totalToPayLabel_.font = detailFont;
        totalToPayLabel_.textColor = labelColor;
        totalToPayLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:totalToPayLabel_];
        
        totalPerPersonLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalPerPersonLabel_.backgroundColor = [UIColor clearColor];
        totalPerPersonLabel_.font = detailFont;
        totalPerPersonLabel_.textColor = labelColor;
        totalPerPersonLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:totalPerPersonLabel_];
    }
    return self;
}

- (void)dealloc
{
    [totalTipTitleLabel_ release];
    [totalToPayTitleLabel_ release];
    [totalPerPersonTitleLabel_ release];
    [totalTipLabel_ release];
    [totalToPayLabel_ release];
    [totalPerPersonLabel_ release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define kLabelHeight 36.0
#define kTitleLabelWidth 110.0
#define kDetailLabelWidth 127.0
    
    totalTipTitleLabel_.frame = CGRectMake(13.0, 42.0, kTitleLabelWidth, kLabelHeight);
    totalToPayTitleLabel_.frame = CGRectMake(13.0, 80.0, kTitleLabelWidth, kLabelHeight);
    totalPerPersonTitleLabel_.frame = CGRectMake(13.0, 117.0, kTitleLabelWidth, kLabelHeight);
    totalTipLabel_.frame = CGRectMake(123.0, 42.0, kDetailLabelWidth, kLabelHeight);
    totalToPayLabel_.frame = CGRectMake(123.0, 80.0, kDetailLabelWidth, kLabelHeight);
    totalPerPersonLabel_.frame = CGRectMake(123.0, 117.0, kDetailLabelWidth, kLabelHeight);
}

@end
