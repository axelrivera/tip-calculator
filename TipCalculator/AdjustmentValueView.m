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
@synthesize segmentedControl = segmentedControl_;

+ (AdjustmentValueView *)adjustmentViewForCellWithTag:(NSInteger)tag
{
    CGRect frame = CGRectMake(0.0, 0.0, 280.0, 44.0);
    AdjustmentValueView *adjustment = [[[[self class] alloc] initWithFrame:frame] autorelease];
    adjustment.titleLabel.tag = tag;
    adjustment.segmentedControl.tag = tag;
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
        
        NSArray *items = [[NSArray alloc] initWithObjects:@"-", @"+", nil];
        segmentedControl_ = [[UISegmentedControl alloc] initWithItems:items];
        [segmentedControl_ setWidth:44.0f forSegmentAtIndex:0];
        [segmentedControl_ setWidth:44.0f forSegmentAtIndex:1];
        segmentedControl_.segmentedControlStyle = UISegmentedControlStylePlain;
        segmentedControl_.momentary = YES;
        [items release];
        [self addSubview:segmentedControl_];
    }
    return self;
}

- (void)dealloc
{
    [titleLabel_ release];
    [segmentedControl_ release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define kXOffset 10.0f
    
    CGRect segmentFrame = segmentedControl_.frame;
    
    segmentedControl_.frame = CGRectMake(0.0,
                                         0.0,
                                         segmentFrame.size.width,
                                         segmentFrame.size.height);
    
    CGRect titleFrame = CGRectMake(segmentFrame.size.width + kXOffset,
                                   0.0,
                                   self.frame.size.width - (segmentFrame.size.width + kXOffset),
                                   segmentFrame.size.height);
    titleLabel_.frame = titleFrame;
}

@end
