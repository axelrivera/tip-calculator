//
//  RLNumberPad.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/26/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RLNumberPad.h"

#define kNumberOfButtons 13
#define kPortraitWidth 320.0
#define kPortraitHeight 236.0
#define kHorizontalPadding 16.0
#define kVerticalPadding 12.0
#define kHorizontalOffset 8.0
#define kVerticalOffset 12.0
#define kDefaultButtonWidth 66.0
#define kDefaultButtonHeight 44.0
#define kZeroButtonWidth 140.0
#define kZeroButtonHeight kDefaultButtonHeight
#define kDoneButtonWidth kDefaultButtonWidth
#define kDoneButtonHeight (kDefaultButtonHeight * 3.0) + (kVerticalOffset * 2.0)

@interface RLNumberPad (Private)

- (void)setupButtons;
- (NSString *)stringForType:(RLNumberPadType)type title:(BOOL)title;

@end

@implementation RLNumberPad

@synthesize delegate = delegate_;
@synthesize callerView = callerView_;

- (id)initDefaultNumberPad
{
    CGRect frame = CGRectMake(0.0, 0.0, kPortraitWidth, kPortraitHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"numberpad_bg.png"]];
        [self setupButtons];
    }
    return self;
}

- (void)dealloc
{
    delegate_ = nil;
    callerView_ = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger tag = 1; tag <= kNumberOfButtons; tag++) {
        UIButton *button = (UIButton *)[self viewWithTag:tag];
        NSAssert(button != nil, @"Button is Nil");
        
        CGRect buttonFrame = CGRectZero;
        
        switch (button.tag) {
            case RLNumberPadSeven:
                buttonFrame = CGRectMake(kHorizontalPadding,
                                         kVerticalPadding,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadEight:
                buttonFrame = CGRectMake(kHorizontalPadding + kDefaultButtonWidth + kHorizontalOffset,
                                         kVerticalPadding,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadNine:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 2.0) + (kHorizontalOffset * 2.0),
                                         kVerticalPadding,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadFour:
                buttonFrame = CGRectMake(kHorizontalPadding,
                                         kVerticalPadding + kDefaultButtonHeight + kVerticalOffset,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadFive:
                buttonFrame = CGRectMake(kHorizontalPadding + kDefaultButtonWidth + kHorizontalOffset,
                                         kVerticalPadding + kDefaultButtonHeight + kVerticalOffset,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadSix:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 2.0) + (kHorizontalOffset * 2.0),
                                         kVerticalPadding + kDefaultButtonHeight + kVerticalOffset,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadOne:
                buttonFrame = CGRectMake(kHorizontalPadding,
                                         kVerticalPadding + (kDefaultButtonHeight * 2.0) + (kVerticalOffset * 2.0),
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadTwo:
                buttonFrame = CGRectMake(kHorizontalPadding + kDefaultButtonWidth + kHorizontalOffset,
                                         kVerticalPadding + (kDefaultButtonHeight * 2.0) + (kVerticalOffset * 2.0),
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadThree:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 2.0) + (kHorizontalOffset * 2.0),
                                         kVerticalPadding + (kDefaultButtonHeight * 2.0) + (kVerticalOffset * 2.0),
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadZero:
                buttonFrame = CGRectMake(kHorizontalPadding,
                                         kVerticalPadding + (kDefaultButtonHeight * 3.0) + (kVerticalOffset * 3.0),
                                         kZeroButtonWidth,
                                         kZeroButtonHeight);
                break;
            case RLNumberPadPeriod:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 2.0) + (kHorizontalOffset * 2.0),
                                         kVerticalPadding + (kDefaultButtonHeight * 3.0) + (kVerticalOffset * 3.0),
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadClear:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 3.0) + (kHorizontalOffset * 3.0),
                                         kVerticalPadding,
                                         kDefaultButtonWidth,
                                         kDefaultButtonHeight);
                break;
            case RLNumberPadDone:
                buttonFrame = CGRectMake(kHorizontalPadding + (kDefaultButtonWidth * 3.0) + (kHorizontalOffset * 3.0),
                                         kVerticalPadding + kDefaultButtonHeight + kVerticalOffset,
                                         kDoneButtonWidth,
                                         kDoneButtonHeight);
                break;
            default:
                [NSException raise:NSGenericException
							format:@"%@: Unexpected Button Type", NSStringFromClass([self class])];
                break;
        }
        button.frame = buttonFrame;
    }
}

#pragma mark - Private Methods

- (void)setupButtons
{
    for (NSInteger tag = 1; tag <= kNumberOfButtons; tag++) {
		UIButton *button = nil;
		if (tag >= 1 && tag <= 11) {
			UIImage *image = [UIImage imageNamed:@"numberpad_button_black.png"];
			UIImage *background = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDefaultButtonHeight];
			UIImage *hImage = [UIImage imageNamed:@"numberpad_button_black_pressed.png"];
			UIImage *hBackground = [hImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDefaultButtonHeight];
			button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			[button setBackgroundImage:background forState:UIControlStateNormal];
			[button setBackgroundImage:hBackground forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
			button.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
			button.adjustsImageWhenHighlighted = NO;
		} else if (tag == 12) {
			UIImage *image = [UIImage imageNamed:@"numberpad_button_yellow.png"];
			UIImage *background = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDefaultButtonHeight];
			UIImage *hImage = [UIImage imageNamed:@"numberpad_button_yellow_pressed.png"];
			UIImage *hBackground = [hImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDefaultButtonHeight];
			button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			[button setBackgroundImage:background forState:UIControlStateNormal];
			[button setBackgroundImage:hBackground forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
			button.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
			button.adjustsImageWhenHighlighted = NO;
		} else {
			UIImage *image = [UIImage imageNamed:@"numberpad_button_done.png"];
			UIImage *background = [image stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDoneButtonHeight];
			UIImage *hImage = [UIImage imageNamed:@"numberpad_button_done_pressed.png"];
			UIImage *hBackground = [hImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:kDoneButtonHeight];
			button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			[button setBackgroundImage:background forState:UIControlStateNormal];
			[button setBackgroundImage:hBackground forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
			button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
			button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
			button.adjustsImageWhenHighlighted = NO;
		}
        [button setTitle:[self stringForType:(RLNumberPadType)tag title:YES] forState:UIControlStateNormal];
        button.tag = tag;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button release];
    }
}

- (NSString *)stringForType:(RLNumberPadType)type title:(BOOL)title;
{
    NSString *string = nil;
    switch (type) {
        case RLNumberPadOne:
            string = @"1";
            break;
        case RLNumberPadTwo:
            string = @"2";
            break;
        case RLNumberPadThree:
            string = @"3";
            break;
        case RLNumberPadFour:
            string = @"4";
            break;
        case RLNumberPadFive:
            string = @"5";
            break;
        case RLNumberPadSix:
            string = @"6";
            break;
        case RLNumberPadSeven:
            string = @"7";
            break;
        case RLNumberPadEight:
            string = @"8";
            break;
        case RLNumberPadNine:
            string = @"9";
            break;
        case RLNumberPadZero:
            string = @"0";
            break;
        case RLNumberPadPeriod:
            string = @".";
            break;
        case RLNumberPadClear:
            if (title) {
                string = @"C";
            } else {
                string = @"";
            }
            break;
        case RLNumberPadDone:
            if (title) {
                string = @"Done";
            } else {
                string = @"";
            }
            break;
        default:
            [NSException raise:NSGenericException
						format:@"%@: Unexpected Button Type", NSStringFromClass([self class])];
            break;
    }
    return string;
}

#pragma mark - Action Methods

- (void)buttonAction:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    UIButton *button = (UIButton *)sender;
    
    RLNumberPadType type = (RLNumberPadType)button.tag;
    if (type == RLNumberPadClear) {
        [delegate_ didPressClearButtonForCallerView:callerView_];
    } else if (type == RLNumberPadDone) {
        [delegate_ didPressReturnButtonForCallerView:callerView_];
    } else {
        [delegate_ didPressButtonWithString:[self stringForType:type title:NO] callerView:callerView_];
    }
}

#pragma mark - UIInputViewAudioFeedback Delegate Methods

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

@end
