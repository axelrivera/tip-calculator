//
//  NumberPadInputView.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "InputDisplayView.h"
#import "UIColor+TipCalculator.h"

@implementation InputDisplayView

@synthesize textLabel = textLabel_;
@synthesize detailTextLabel = detailTextLabel_;
@synthesize inputView, inputAccessoryView;

- (id)initWithFrame:(CGRect)frame
{
    CGRect defaultFrame = CGRectMake(frame.origin.x,
                                     frame.origin.y,
                                     frame.size.width,
                                     37.0f);
    self = [super initWithFrame:defaultFrame];
    if (self) {
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        
        textLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
        textLabel_.backgroundColor = [UIColor clearColor];
        textLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:textLabel_];
        
        detailTextLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel_.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:18.0];
        detailTextLabel_.backgroundColor = [UIColor clearColor];
        detailTextLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:detailTextLabel_];
        
        UIImage *normalImage = [UIImage imageNamed:@"select_view_normal.png"];
        UIImage *normalBackground = [normalImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37.0];
        [self setBackgroundImage:normalBackground forState:UIControlStateNormal];
        
        UIImage *selectedImage = [UIImage imageNamed:@"select_view_highlighted.png"];
        UIImage *selectedBackground = [selectedImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37];
        [self setBackgroundImage:selectedBackground forState:UIControlStateSelected];
        
        self.selected = NO;
    }
    return self;
}

- (void)dealloc
{
    [textLabel_ release];
    [detailTextLabel_ release];
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
    textLabel_.frame = CGRectMake(kHorizontalPadding,
                                   kVerticalPadding,
                                   kTitleLabelWidth,
                                   kLabelHeight);
    CGFloat detailTextWidth = self.frame.size.width - (kHorizontalPadding + kTitleLabelWidth + kLabelOffset + kHorizontalPadding);
    detailTextLabel_.frame = CGRectMake(kHorizontalPadding + kTitleLabelWidth + kLabelOffset,
                                         kVerticalPadding,
                                         detailTextWidth,
                                         kLabelHeight);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *color = nil;
    if (selected == YES) {
        color = [UIColor selectedViewHighlightedColor];
    } else {
        color = [UIColor selectedViewNormalColor];
    }
    textLabel_.textColor = color;
    detailTextLabel_.textColor = color;
}

- (void)setHighlighted:(BOOL)highlighted
{
    // Disable Highlighting to avoid weird color issues in label colors
}

@end
