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
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
		
		imageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guest_check_background.png"]];
		[self addSubview:imageView_];
        
        UIFont *titleFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:17.0];
        UIFont *detailFont = [UIFont fontWithName:@"MarkerFelt-Wide" size:16.0];
        UIColor *labelColor = [UIColor whiteColor];
        
        totalTipTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalTipTitleLabel_.backgroundColor = [UIColor clearColor];
        totalTipTitleLabel_.font = titleFont;
        totalTipTitleLabel_.textColor = labelColor;
        totalTipTitleLabel_.text = @"Total Tip";
        totalTipTitleLabel_.textAlignment = UITextAlignmentLeft;
        [imageView_ addSubview:totalTipTitleLabel_];
        
        totalToPayTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalToPayTitleLabel_.backgroundColor = [UIColor clearColor];
        totalToPayTitleLabel_.font = titleFont;
        totalToPayTitleLabel_.textColor = labelColor;
        totalToPayTitleLabel_.text = @"Total to Pay";
        totalToPayTitleLabel_.textAlignment = UITextAlignmentLeft;
        [imageView_ addSubview:totalToPayTitleLabel_];
        
        totalPerPersonTitleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalPerPersonTitleLabel_.backgroundColor = [UIColor clearColor];
        totalPerPersonTitleLabel_.font = titleFont;
        totalPerPersonTitleLabel_.textColor = labelColor;
        totalPerPersonTitleLabel_.text = @"Total per Person";
        totalPerPersonTitleLabel_.textAlignment = UITextAlignmentLeft;
        [imageView_ addSubview:totalPerPersonTitleLabel_];
        
        totalTipLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalTipLabel_.backgroundColor = [UIColor clearColor];
        totalTipLabel_.font = detailFont;
        totalTipLabel_.textColor = labelColor;
        totalTipLabel_.textAlignment = UITextAlignmentRight;
		totalTipLabel_.minimumFontSize = 12.0;
		totalTipLabel_.adjustsFontSizeToFitWidth = YES;
        [imageView_ addSubview:totalTipLabel_];
        
        totalToPayLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalToPayLabel_.backgroundColor = [UIColor clearColor];
        totalToPayLabel_.font = detailFont;
        totalToPayLabel_.textColor = labelColor;
        totalToPayLabel_.textAlignment = UITextAlignmentRight;
		totalToPayLabel_.minimumFontSize = 12.0;
		totalToPayLabel_.adjustsFontSizeToFitWidth = YES;
        [imageView_ addSubview:totalToPayLabel_];
        
        totalPerPersonLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        totalPerPersonLabel_.backgroundColor = [UIColor clearColor];
        totalPerPersonLabel_.font = detailFont;
        totalPerPersonLabel_.textColor = labelColor;
        totalPerPersonLabel_.textAlignment = UITextAlignmentRight;
		totalPerPersonLabel_.minimumFontSize = 12.0;
		totalPerPersonLabel_.adjustsFontSizeToFitWidth = YES;
        [imageView_ addSubview:totalPerPersonLabel_];
    }
    return self;
}

- (void)dealloc
{
	[imageView_ release];
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
