//
//  NumberPadInputView.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "InputDisplayView.h"
#import "UIColor+TipCalculator.h"

#define kInputViewImage @"input_accessory_down_white.png"
#define kInputViewImageSelected @"input_accessory_up_blue.png"

@implementation InputDisplayView

@synthesize textLabel = textLabel_;
@synthesize detailTextLabel = detailTextLabel_;
@synthesize accessoryView = accessoryView_;
@synthesize textColor = textColor_;
@synthesize textColorSelected = textColorSelected_;
@synthesize imageAccessory = imageAccessory_;
@synthesize imageAccessorySelected = imageAccessorySelected_;
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
		
		textColor_ = [[UIColor selectedViewNormalColor] retain];
		textColorSelected_ = [[UIColor selectedViewHighlightedColor] retain];
		imageAccessory_ = [[UIImage imageNamed:kInputViewImage] retain];
		imageAccessorySelected_ = [[UIImage imageNamed:kInputViewImageSelected] retain];
        
        textLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel_.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18.0];
        textLabel_.backgroundColor = [UIColor clearColor];
        textLabel_.textAlignment = UITextAlignmentLeft;
        [self addSubview:textLabel_];
        
        detailTextLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel_.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:17.0];
        detailTextLabel_.backgroundColor = [UIColor clearColor];
        detailTextLabel_.textAlignment = UITextAlignmentRight;
        [self addSubview:detailTextLabel_];
        
        UIImage *normalImage = [UIImage imageNamed:@"select_view_black.png"];
        UIImage *normalBackground = [normalImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37.0];
        [self setBackgroundImage:normalBackground forState:UIControlStateNormal];
        
        UIImage *selectedImage = [UIImage imageNamed:@"select_view_white.png"];
        UIImage *selectedBackground = [selectedImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:37];
        [self setBackgroundImage:selectedBackground forState:UIControlStateSelected];
        
		accessoryView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kInputViewImage]];
		[self addSubview:accessoryView_];
		
        self.selected = NO;
    }
    return self;
}

- (void)dealloc
{
    [textLabel_ release];
    [detailTextLabel_ release];
	[accessoryView_ release];
	[textColor_ release];
	[textColorSelected_ release];
	[imageAccessory_ release];
	[imageAccessorySelected_ release];
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
#define kTitleLabelWidth 115.0f
#define kLabelHeight 18.0f
#define kLabelOffset 5.0f
    textLabel_.frame = CGRectMake(kHorizontalPadding,
                                   kVerticalPadding,
                                   kTitleLabelWidth,
                                   kLabelHeight);
	CGFloat detailTextWidth = self.frame.size.width - (kHorizontalPadding + kTitleLabelWidth + kLabelOffset + kHorizontalPadding);
	if (accessoryView_) {
		detailTextWidth -= accessoryView_.frame.size.width + kLabelOffset;
		CGRect accessoryFrame = accessoryView_.frame;
		CGFloat accessoryX = kHorizontalPadding + kTitleLabelWidth + kLabelOffset + detailTextWidth + kLabelOffset;
		accessoryView_.frame = CGRectMake(accessoryX,
										  (self.frame.size.height / 2.0) - (accessoryFrame.size.height / 2.0),
										  accessoryFrame.size.width,
										  accessoryFrame.size.height);
	}
    
	detailTextLabel_.frame = CGRectMake(kHorizontalPadding + kTitleLabelWidth + kLabelOffset,
                                         kVerticalPadding,
                                         detailTextWidth,
                                         kLabelHeight);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *color = nil;
	UIImage *image = nil;
    if (selected == YES) {
        color = textColorSelected_;
		image = imageAccessorySelected_;
    } else {
        color = textColor_;
		image = imageAccessory_;
    }
    textLabel_.textColor = color;
    detailTextLabel_.textColor = color;
	[accessoryView_ setImage:image];
}

- (void)setHighlighted:(BOOL)highlighted
{
    // Disable Highlighting to avoid weird color issues in label colors
}

@end
