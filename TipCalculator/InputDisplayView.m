//
//  NumberPadInputView.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "InputDisplayView.h"

@implementation InputDisplayView

@synthesize titleLabel = titleLabel_;
@synthesize descriptionLabel = descriptionLabel_;
@synthesize inputView, inputAccessoryView;

- (id)initWithFrame:(CGRect)frame
{
    CGRect defaultFrame = CGRectMake(frame.origin.x,
                                     frame.origin.y,
                                     300.0f,
                                     38.0f);
    self = [super initWithFrame:defaultFrame];
    if (self) {
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        self.selected = NO;
        
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel_.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor blackColor];
        titleLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:titleLabel_];
        
        descriptionLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        descriptionLabel_.font = [UIFont systemFontOfSize:16.0];
        descriptionLabel_.backgroundColor = [UIColor clearColor];
        descriptionLabel_.textColor = [UIColor blackColor];
        descriptionLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:descriptionLabel_];
    }
    return self;
}

- (void)dealloc
{
    [titleLabel_ release];
    [descriptionLabel_ release];
    [inputView release];
    [inputAccessoryView release];
    [super dealloc];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.selected = YES;
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    self.selected = NO;
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
#define kVerticalPadding 10.0f
#define kHorizontalPadding 5.0f
#define kTitleLabelWidth 140.0f
#define kLabelHeight 18.0f
#define kLabelOffset 5.0f
    titleLabel_.frame = CGRectMake(kHorizontalPadding,
                                   kVerticalPadding,
                                   kTitleLabelWidth,
                                   kLabelHeight);
    descriptionLabel_.frame = CGRectMake(kHorizontalPadding + kTitleLabelWidth + kLabelOffset,
                                         kVerticalPadding,
                                         self.frame.size.width - (kHorizontalPadding + kTitleLabelWidth + kLabelOffset + kHorizontalPadding),
                                         kLabelHeight);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected == YES) {
        self.backgroundColor = [UIColor cyanColor];
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
