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
@property (nonatomic, copy) NSString *enteredDecimals;
@property (nonatomic, assign) BOOL useDecimalSeparator;

- (id)initWithDigits:(NSString *)digits andDecimals:(NSString *)decimals;
- (id)initWithDecimalNumber:(NSDecimalNumber *)decimalNumber;

- (void)setDigitsAndDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
- (void)resetDigitsAndDecimals;

- (void)addNumber:(NSString *)string;
- (NSUInteger)length;
- (void)validateAndFixDecimalSeparator;

- (NSDecimalNumber *)decimalNumber;
- (NSString *)stringValue;

- (NSString *)description;

@end
