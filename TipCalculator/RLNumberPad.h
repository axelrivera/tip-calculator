//
//  RLNumberPad.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/26/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RLNumberPadOne = 1,
    RLNumberPadTwo = 2,
    RLNumberPadThree = 3,
    RLNumberPadFour = 4,
    RLNumberPadFive = 5,
    RLNumberPadSix = 6,
    RLNumberPadSeven = 7,
    RLNumberPadEight = 8,
    RLNumberPadNine = 9,
    RLNumberPadZero = 10,
    RLNumberPadPeriod = 11,
    RLNumberPadClear = 12,
    RLNumberPadBack = 13,
    RLNumberPadDone = 14
} RLNumberPadType;

@protocol RLNumberPadDelegate <NSObject>

- (void)didPressButtonWithString:(NSString *)string callerView:(UIView *)callerView;
- (void)didPressClearButtonForCallerView:(UIView *)callerView;
- (void)didPressReturnButtonForCallerView:(UIView *)callerView;

@end

@interface RLNumberPad : UIView <UIInputViewAudioFeedback>

@property (nonatomic, assign) id <RLNumberPadDelegate> delegate;
@property (nonatomic, assign) UIView *callerView;

- (id)initDefaultNumberPad;

@end
