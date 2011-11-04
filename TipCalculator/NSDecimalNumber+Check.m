//
//  NSDecimalNumber+Modulo.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDecimalNumber+Check.h"

static NSDecimalNumberHandler *currencyBehavior_;
static NSNumberFormatter *currencyFormatter_;
static NSNumberFormatter *percentFormatter_;

@interface NSDecimalNumber (Private)

- (NSDecimalNumberHandler *)currencyBehavior;
- (NSNumberFormatter *)currencyFormatter;
- (NSNumberFormatter *)percentFormatterWithDecimalPlaces:(NSInteger)decimalPlaces;

@end

@implementation NSDecimalNumber (Check)

- (NSDecimalNumber *)decimalCurrencyByAdding:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberByAdding:decimalNumber withBehavior:[self currencyBehavior]];
}

- (NSDecimalNumber *)decimalCurrencyBySubtracting:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberBySubtracting:decimalNumber withBehavior:[self currencyBehavior]];
}

- (NSDecimalNumber *)decimalCurrencyByMultiplyingBy:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberByMultiplyingBy:decimalNumber withBehavior:[self currencyBehavior]];
}

- (NSDecimalNumber *)decimalCurrencyByDividingBy:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberByDividingBy:decimalNumber withBehavior:[self currencyBehavior]];
}

- (NSDecimalNumber *)decimalNumberByModuloDivision:(NSDecimalNumber *)decimal
{
    NSDecimalNumber *dividend = [NSDecimalNumber decimalNumberWithDecimal:[self decimalValue]];
    NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithDecimal:[decimal decimalValue]];
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    NSDecimalNumber *quotient = [dividend decimalNumberByDividingBy:divisor withBehavior:behavior];
    NSDecimalNumber *subtractAmount = [quotient decimalNumberByMultiplyingBy:divisor];
    NSDecimalNumber *remainder = [dividend decimalNumberBySubtracting:subtractAmount];
    return remainder;
}

- (BOOL)isEqualToZero
{
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (NSString *)currencyString
{
    return [[self currencyFormatter] stringFromNumber:self];
}

- (NSString *)percentString
{
    return [self percentStringWithDecimalPlaces:0];
}

- (NSString *)percentStringWithDecimalPlaces:(NSInteger)decimalPlaces
{
    return [[self percentFormatterWithDecimalPlaces:decimalPlaces] stringFromNumber:self];
}

#pragma mark - Private Methods

- (NSDecimalNumberHandler *)currencyBehavior
{
    if (currencyBehavior_ == nil) {
        currencyBehavior_ = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown
                                                                           scale:2
                                                                raiseOnExactness:NO
                                                                 raiseOnOverflow:NO
                                                                raiseOnUnderflow:NO
                                                             raiseOnDivideByZero:NO];
    }
    return currencyBehavior_;
}

- (NSNumberFormatter *)currencyFormatter
{
    if (currencyFormatter_ == nil) {
        currencyFormatter_ = [[NSNumberFormatter alloc] init];
        currencyFormatter_.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return currencyFormatter_;
}

- (NSNumberFormatter *)percentFormatterWithDecimalPlaces:(NSInteger)decimalPlaces
{
    if (percentFormatter_ == nil) {
        percentFormatter_ = [[NSNumberFormatter alloc] init];
        percentFormatter_.numberStyle = NSNumberFormatterPercentStyle;
        percentFormatter_.maximumFractionDigits = decimalPlaces;
    }
    return percentFormatter_;
}

@end
