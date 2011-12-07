//
//  NSDecimalNumber+Modulo.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDecimalNumber+Check.h"
#import "Settings.h"

@interface NSDecimalNumber (Private)

- (NSDecimalNumberHandler *)currencyBehavior;
- (NSDecimalNumberHandler *)currencyBehaviorWithRounding:(NSRoundingMode)rounding;

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

- (NSDecimalNumber *)decimalCurrencyByDividingBy:(NSDecimalNumber *)decimalNumber rounding:(NSRoundingMode)rounding
{
	return [self decimalNumberByDividingBy:decimalNumber withBehavior:[self currencyBehaviorWithRounding:rounding]];
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

- (NSDecimalNumber *)decimalCurrencyByRoundingDown
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    return [self decimalNumberByRoundingAccordingToBehavior:behavior];
}

- (NSDecimalNumber *)decimalCurrencyByRoundingUp
{
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp
                                                                                              scale:0
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    return [self decimalNumberByRoundingAccordingToBehavior:behavior];
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
    return [[[self class] currencyFormatter] stringFromNumber:self];
}

- (NSString *)percentString
{
    return [[[self class] percentFormatter] stringFromNumber:self];
}

- (NSString *)taxString
{
    return [[[self class] taxFormatter] stringFromNumber:self];
}

#pragma mark - Private Methods

- (NSDecimalNumberHandler *)currencyBehavior
{
    return [[[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain
                                                           scale:2
                                                raiseOnExactness:NO
                                                 raiseOnOverflow:NO
                                                raiseOnUnderflow:NO
                                             raiseOnDivideByZero:NO] autorelease];
}

- (NSDecimalNumberHandler *)currencyBehaviorWithRounding:(NSRoundingMode)rounding
{
    return [[[NSDecimalNumberHandler alloc] initWithRoundingMode:rounding
                                                           scale:2
                                                raiseOnExactness:NO
                                                 raiseOnOverflow:NO
                                                raiseOnUnderflow:NO
                                             raiseOnDivideByZero:NO] autorelease];
}

#pragma mark - Class Methods

+ (NSNumberFormatter *)currencyFormatter
{
    NSNumberFormatter *currencyFormatter_ = [[[NSNumberFormatter alloc] init] autorelease];
    currencyFormatter_.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter_.locale = [[Settings sharedSettings] currentLocale];
    return currencyFormatter_;
}

+ (NSNumberFormatter *)percentFormatter
{
    NSNumberFormatter *percentFormatter_ = [[[NSNumberFormatter alloc] init] autorelease];
    percentFormatter_.numberStyle = NSNumberFormatterPercentStyle;
    return percentFormatter_;
}

+ (NSNumberFormatter *)taxFormatter
{
    NSNumberFormatter *taxFormatter_ = [[[NSNumberFormatter alloc] init] autorelease];
    taxFormatter_.numberStyle = NSNumberFormatterDecimalStyle;
    [taxFormatter_ setPositiveFormat:@"#0.00'%'"];
    [taxFormatter_ setNegativeFormat:@"-#0.00'%'"];
    [taxFormatter_ setMinimumFractionDigits:2];
    [taxFormatter_ setMaximumFractionDigits:2];
    return taxFormatter_;
}

@end
