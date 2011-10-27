//
//  AdjustmentBalanceView.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/26/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "AdjustmentBalanceView.h"

@implementation AdjustmentBalanceView

@synthesize line1 = line1_;
@synthesize line2 = line2_;
@synthesize line3 = line3_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        line1_ = [[UILabel alloc] initWithFrame:CGRectZero];
        line1_.backgroundColor = [UIColor clearColor];
        line1_.font = [UIFont systemFontOfSize:14.0];
        line1_.textColor = [UIColor blackColor];
        line1_.textAlignment = UITextAlignmentLeft;
        line1_.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:line1_];
        
        line2_ = [[UILabel alloc] initWithFrame:CGRectZero];
        line2_.backgroundColor = [UIColor clearColor];
        line2_.font = [UIFont systemFontOfSize:14.0];
        line2_.textColor = [UIColor blackColor];
        line2_.textAlignment = UITextAlignmentLeft;
        line2_.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:line2_];
        
        line3_ = [[UILabel alloc] initWithFrame:CGRectZero];
        line3_.backgroundColor = [UIColor clearColor];
        line3_.font = [UIFont systemFontOfSize:14.0];
        line3_.textColor = [UIColor blackColor];
        line3_.textAlignment = UITextAlignmentLeft;
        line3_.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:line3_];
    }
    return self;
}

- (void)dealloc
{
    [line1_ release];
    [line2_ release];
    [line3_ release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
#define kLabelHeight 17.0
#define kOffset 5.0
    CGRect adjustmentFrame = self.frame;
    
    line1_.frame = CGRectMake(0.0f,
                              0.0f,
                              adjustmentFrame.size.width,
                              kLabelHeight);
    line2_.frame = CGRectMake(0.0f,
                              kLabelHeight + kOffset,
                              adjustmentFrame.size.width,
                              kLabelHeight);
    line3_.frame = CGRectMake(0.0f,
                              kLabelHeight + kOffset + kLabelHeight + kOffset,
                              adjustmentFrame.size.width,
                              kLabelHeight);
}

@end
