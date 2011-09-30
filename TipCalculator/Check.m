//
//  Check.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Check.h"

#define kDefaultNumberOfSplits @"2"
#define kDefaultTipPercentage  @"0.15"
#define kDefaultCheckAmount @"100.00"

@interface Check (Private)

- (NSString *)currencyStringForNumber:(NSNumber *)number;
- (NSString *)percentageStringForNumber:(NSNumber *)number;

@end

@implementation Check

@synthesize numberOfSplits = numberOfSplits_;
@synthesize tipPercentage = tipPercentage_;
@synthesize checkAmount = checkAmount_;

- (id)init
{
    self = [super init];
    if (self) {
        self.numberOfSplits = [NSDecimalNumber decimalNumberWithString:kDefaultNumberOfSplits];
        self.tipPercentage = [NSDecimalNumber decimalNumberWithString:kDefaultTipPercentage];
        self.checkAmount = [NSDecimalNumber decimalNumberWithString:kDefaultCheckAmount];
    }
    return self;
}

- (NSDecimalNumber *)totalTip
{
    return [checkAmount_ decimalNumberByMultiplyingBy:tipPercentage_];
}

- (NSDecimalNumber *)totalToPay
{
    NSDecimalNumber *tip = [self totalTip];
    return [checkAmount_ decimalNumberByAdding:tip];
}

- (NSDecimalNumber *)totalPerPerson
{
    NSDecimalNumber *total = [self totalToPay];
    return [total decimalNumberByDividingBy:numberOfSplits_];
}

- (NSString *)stringForNumberOfSplits
{
    NSString *string = nil;
    if ([numberOfSplits_ integerValue] == 1) {
        string = @"No Split";
    } else {
        string = [NSString stringWithFormat:@"%d People", [numberOfSplits_ integerValue]];
    }
    return string;
}

- (NSString *)stringForTipPercentage
{
    return [self percentageStringForNumber:tipPercentage_];
}

- (NSString *)stringForCheckAmount
{
    return [self currencyStringForNumber:checkAmount_];
}

- (NSString *)stringForTotalTip
{
    return [self currencyStringForNumber:[self totalTip]];
}

- (NSString *)stringForTotalToPay
{
    return [self currencyStringForNumber:[self totalToPay]];
}

- (NSString *)stringForTotalPerPerson
{
    return [self currencyStringForNumber:[self totalPerPerson]];
}

#pragma mark - Private Methods

- (NSString *)currencyStringForNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *string = [formatter stringFromNumber:number];
    [formatter release];
    return string;
}

- (NSString *)percentageStringForNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    NSString *string = [formatter stringFromNumber:number];
    [formatter release];
    return string;
}

@end
