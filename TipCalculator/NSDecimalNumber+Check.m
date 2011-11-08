//
//  NSDecimalNumber+Modulo.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDecimalNumber+Check.h"
#import "Settings.h"

static NSDecimalNumberHandler *currencyBehavior_;
static NSNumberFormatter *currencyFormatter_;
static NSNumberFormatter *percentFormatter_;
static NSNumberFormatter *taxFormatter_;

@interface NSDecimalNumber (Private)

- (NSDecimalNumberHandler *)currencyBehavior;

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

#pragma mark - Class Methods

+ (NSNumberFormatter *)currencyFormatter
{
    if (currencyFormatter_ == nil) {
        currencyFormatter_ = [[NSNumberFormatter alloc] init];
    }
    currencyFormatter_.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormatter_.locale = [[Settings sharedSettings] currentLocale];
    return currencyFormatter_;
}

+ (NSNumberFormatter *)percentFormatter
{
    if (percentFormatter_ == nil) {
        percentFormatter_ = [[NSNumberFormatter alloc] init];
        percentFormatter_.numberStyle = NSNumberFormatterPercentStyle;
    }
    return percentFormatter_;
}

+ (NSNumberFormatter *)taxFormatter
{
    if (taxFormatter_ == nil) {
        taxFormatter_ = [[NSNumberFormatter alloc] init];
        taxFormatter_.numberStyle = NSNumberFormatterDecimalStyle;
        [taxFormatter_ setPositiveFormat:@"#0.00'%'"];
        [taxFormatter_ setNegativeFormat:@"-#0.00'%'"];
        [taxFormatter_ setMinimumFractionDigits:2];
        [taxFormatter_ setMaximumFractionDigits:2];
    }
    return taxFormatter_;
}

@end
