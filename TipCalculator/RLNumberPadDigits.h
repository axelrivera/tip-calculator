//
//  RLNumberPadFormatter.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLNumberPadDigits : NSObject

@property (nonatomic, copy) NSString *enteredDigits;

- (id)initWithDigits:(NSString *)digits;
- (id)initWithDecimalNumber:(NSDecimalNumber *)decimal;

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimal;

- (void)addDigit:(NSString *)string;

- (NSDecimalNumber *)decimalNumberForEnteredDigits;
- (NSString *)stringForEnteredDigits;

@end
