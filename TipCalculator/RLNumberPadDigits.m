//
//  RLNumberPadFormatter.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RLNumberPadDigits.h"
#import "NSDecimalNumber+Check.h"

#define kCurrencyScale -2

static NSNumberFormatter *digitsFormatter_;

@interface RLNumberPadDigits (Private)

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
- (void)setEnteredDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber;

- (void)addNumberToDigits:(NSString *)string;
- (void)addNumberToDecimals:(NSString *)string;

- (void)removeLastDigit;
- (void)removeLastDecimal;

+ (NSString *)defaultCurrencySymbol;
+ (NSString *)defaultDecimalSeparator;
+ (NSNumberFormatter *)digitsFormatter;

@end

@implementation RLNumberPadDigits

@synthesize enteredDigits = enteredDigits_;
@synthesize enteredDecimals = enteredDecimals_;
@synthesize useDecimalSeparator = useDecimalSeparator_;

- (id)init
{
    self = [super init];
    if (self) {
        self.enteredDigits = @"";
        self.enteredDecimals = @"";
        self.useDecimalSeparator = NO;
    }
    return self;
}

- (id)initWithDigits:(NSString *)digits andDecimals:(NSString *)decimals
{
    self = [self init];
    if (self) {
        self.enteredDigits = digits;
        self.enteredDecimals = decimals;
    }
    return self;
}

- (id)initWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    self = [self init];
    if (self) {
        [self setDigitsAndDecimalsWithDecimalNumber:decimalNumber];
    }
    return self;
}

- (void)dealloc
{
    [enteredDigits_ release];
    [enteredDecimals_ release];
    [super dealloc];
}

#pragma mark - Custom Methods

- (void)setDigitsAndDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *dollars = [NSDecimalNumber zero];
    NSDecimalNumber *cents = [NSDecimalNumber zero];
    NSComparisonResult decimalCompare = [decimalNumber compare:[NSDecimalNumber zero]];
    if (decimalCompare != NSOrderedSame) {
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                  scale:2
                                                                                       raiseOnExactness:NO
                                                                                        raiseOnOverflow:NO
                                                                                       raiseOnUnderflow:NO
                                                                                    raiseOnDivideByZero:NO];
        dollars = [decimalNumber decimalNumberByRoundingAccordingToBehavior:behavior];
        cents = [decimalNumber decimalNumberBySubtracting:dollars];
        cents = [cents decimalNumberByMultiplyingByPowerOf10:abs(kCurrencyScale)];
    }
    [self setEnteredDigitsWithDecimalNumber:dollars];
    [self setEnteredDecimalsWithDecimalNumber:cents];
}

- (void)resetDigitsAndDecimals
{
    self.enteredDigits = @"";
    self.enteredDecimals = @"";
    useDecimalSeparator_ = NO;
}

- (void)addNumber:(NSString *)string
{	
	if ([string isEqualToString:@"0"] && [self length] == 0) {
		return;
	}
    
    if (![string isEqualToString:@""] && useDecimalSeparator_ == YES && [enteredDecimals_ length] >= abs(kCurrencyScale)) {
        return;
    }
    
    if (useDecimalSeparator_ == NO && [string isEqualToString:@"."]) {
        useDecimalSeparator_ = YES;
    }
	
	// Check the length of the string
	if ([string length] > 0) {
        if (!useDecimalSeparator_) {
            [self addNumberToDigits:string];
        } else {
            [self addNumberToDecimals:string];
        }
	} else {
		if (!useDecimalSeparator_) {
            [self removeLastDigit];
        } else {
            [self removeLastDecimal];
        }
	}	
}

- (NSUInteger)length
{
    return [enteredDigits_ length] + [enteredDecimals_ length];
}

- (void)validateAndFixDecimalSeparator
{
    if (useDecimalSeparator_ && [enteredDecimals_ length] == 0) {
        useDecimalSeparator_ = NO;
    }
}

- (NSDecimalNumber *)decimalNumber
{
    NSMutableString *decimalStr = [NSMutableString string];
	if (![enteredDigits_ isEqualToString:@""]) {
		[decimalStr appendString:enteredDigits_];
	} else {
		[decimalStr appendString:@"0"];
	}
    if (useDecimalSeparator_ && ![enteredDecimals_ isEqualToString:@""]) {
        [decimalStr appendFormat:@".%@", enteredDecimals_];
    }
    return [NSDecimalNumber decimalNumberWithString:decimalStr];
}

- (NSString *)stringValue
{
    NSNumberFormatter *formatter = [[NSDecimalNumber currencyFormatter] copy];
    
    NSString *dollarsStr = @"0";
    if (![enteredDigits_ isEqualToString:@""]) {
        dollarsStr = enteredDigits_;
    }
    NSString *centsStr  = enteredDecimals_;
    
    NSString *string = [[NSArray arrayWithObjects:dollarsStr, centsStr, nil] componentsJoinedByString:@"."];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:string];
    
    formatter.minimumFractionDigits = [centsStr length];
    formatter.maximumFractionDigits = [centsStr length];
    
    if ([centsStr length] == 0 && useDecimalSeparator_) {
        formatter.alwaysShowsDecimalSeparator = YES;
    } else {
        formatter.alwaysShowsDecimalSeparator = NO;
    }
    
    NSString *decimalStr = [formatter stringFromNumber:decimalNumber];
    [formatter release];
    
    return decimalStr;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Digits: %@, Decimals: %@, Number: %@, String: %@",
            enteredDigits_,
            enteredDecimals_,
            [self decimalNumber],
            [self stringValue]];
}

#pragma mark - Private Methods

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSString *string = @"";
    if (![decimalNumber isEqualToZero]) {
        string = [decimalNumber stringValue];
    }
    self.enteredDigits = string;
}

- (void)setEnteredDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSString *string = @"";
    if (![decimalNumber isEqualToZero]) {
        string = [decimalNumber stringValue];
    }
    self.enteredDecimals = string;
}

- (void)addNumberToDigits:(NSString *)string
{
    NSMutableString *digits = [NSMutableString stringWithString:enteredDigits_];
    [digits appendString:string];
    self.enteredDigits = digits;
}

- (void)addNumberToDecimals:(NSString *)string
{
    if ([string isEqualToString:@"."]) {
        return;
    }
    NSMutableString *decimals = [NSMutableString stringWithString:enteredDecimals_];
    [decimals appendString:string];
    self.enteredDecimals = decimals;
}

- (void)removeLastDigit
{
    if ([enteredDigits_ length] > 0) {
        NSString *digits = [enteredDigits_ substringToIndex:[enteredDigits_ length] - 1];
        self.enteredDigits = digits;
    } 
}

- (void)removeLastDecimal
{
    if ([enteredDecimals_ length] > 0) {
        NSString *decimals = [enteredDecimals_ substringToIndex:[enteredDecimals_ length] - 1];
        if ([decimals length] == 0) {
            useDecimalSeparator_ = NO;
        }
        self.enteredDecimals = decimals;
    }
}

+ (NSString *)defaultCurrencySymbol
{
    return @"$";
}

+ (NSString *)defaultDecimalSeparator
{
    return @".";
}

+ (NSNumberFormatter *)digitsFormatter
{
    if (digitsFormatter_ == nil) {
        digitsFormatter_ = [[NSNumberFormatter alloc] init];
        digitsFormatter_.numberStyle = NSNumberFormatterDecimalStyle;
        digitsFormatter_.maximumFractionDigits = 0;
    }
    return digitsFormatter_;
}

@end
