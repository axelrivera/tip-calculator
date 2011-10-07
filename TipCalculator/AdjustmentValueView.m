//
//  AdjustmentValueView.m
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentValueView.h"

@implementation AdjustmentValueView

@synthesize titleLabel = titleLabel_;
@synthesize leftButton = leftButton_;
@synthesize rightButton = rightButton_;
@synthesize slider = slider_;

+ (AdjustmentValueView *)adjustmentViewForCellWithTag:(NSInteger)tag
{
    CGRect frame = CGRectMake(0.0, 0.0, 280.0, 50.0);
    AdjustmentValueView *adjustment = [[[[self class] alloc] initWithFrame:frame] autorelease];
    adjustment.titleLabel.tag = tag;
    adjustment.rightButton.tag = tag;
    adjustment.leftButton.tag = tag;
    adjustment.slider.tag = tag;
    return adjustment;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.font = [UIFont systemFontOfSize:14.0];
        titleLabel_.textColor = [UIColor blackColor];
        titleLabel_.textAlignment = UITextAlignmentCenter;
        titleLabel_.lineBreakMode = UILineBreakModeMiddleTruncation;
        [self addSubview:titleLabel_];
        
        leftButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [leftButton_ setTitle:@"-" forState:UIControlStateNormal];
        [self addSubview:leftButton_];
        
        rightButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [rightButton_ setTitle:@"+" forState:UIControlStateNormal];
        [self addSubview:rightButton_];
        
        slider_ = [[UISlider alloc] initWithFrame:CGRectZero];
        [self addSubview:slider_];
    }
    return self;
}

- (void)dealloc
{
    [titleLabel_ release];
    [leftButton_ release];
    [rightButton_ release];
    [slider_ release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect titleFrame = CGRectMake(0.0,
                                   0.0,
                                   self.frame.size.width,
                                   17.0);
    titleLabel_.frame = titleFrame;
    
#define kButtonWidth 34.0
#define kButtonHeight 28.0
#define kButtonOffset 10.0

    CGRect leftFrame = CGRectMake(0.0,
                                   self.frame.size.height - kButtonHeight,
                                   kButtonWidth,
                                   kButtonHeight);
    leftButton_.frame = leftFrame;
    
    CGRect sliderFrame = CGRectMake(kButtonWidth + kButtonOffset,
                                    self.frame.size.height - kButtonHeight,
                                    self.frame.size.width - (kButtonWidth * 2.0 + kButtonOffset * 2.0),
                                    kButtonHeight);
    slider_.frame = sliderFrame;
    
    CGRect rightFrame = CGRectMake(kButtonWidth + kButtonOffset + sliderFrame.size.width + kButtonOffset,
                                   self.frame.size.height - kButtonHeight,
                                   kButtonWidth,
                                   kButtonHeight);
    rightButton_.frame = rightFrame;
}

@end
