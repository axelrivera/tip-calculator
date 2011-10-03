//
//  Check.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Check.h"

#define kStartNumberOfSplits 1
#define kMaximumNumberOfSplits 50

#define kStartTipPercentage 0
#define kMaximumTipPercentage 50
#define kTipPercentageFactor -2

#define kDefaultNumberOfSplits @"2"
#define kDefaultTipPercentage  @"0.15"
#define kDefaultCheckAmount @"100.00"

static NSArray *numberOfSplitsArray;
static NSArray *tipPercentagesArray;
static NSDictionary *numberOfSplitsDictionary;
static NSDictionary *tipPercentagesDictionary;

@interface Check (Private)

+ (NSDictionary *)numberOfSplitsDictionary;
+ (NSDictionary *)tipPercentagesDictionary;

- (NSString *)currencyStringForNumber:(NSNumber *)number;
- (NSString *)percentageStringForNumber:(NSNumber *)number;

@end

@implementation Check

@synthesize numberOfSplits = numberOfSplits_;
@synthesize tipPercentage = tipPercentage_;
@synthesize checkAmount = checkAmount_;

+ (NSArray *)numberOfSplitsArray
{
    if (numberOfSplitsArray == nil) {
        NSMutableArray *splits = [[NSMutableArray alloc] initWithCapacity:kMaximumNumberOfSplits];
        for (NSInteger i = kStartNumberOfSplits; i <= kMaximumNumberOfSplits; i++) {
            NSNumber *number = [NSNumber numberWithInteger:i];
            NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:[number stringValue]];
            [splits addObject:decimal];
        }
        numberOfSplitsArray = [[NSArray alloc] initWithArray:splits];
        [splits release];
    }
    return numberOfSplitsArray;
}

+ (NSArray *)tipPercentagesArray
{
    if (tipPercentagesArray == nil) {
        NSMutableArray *tips = [[NSMutableArray alloc] initWithCapacity:kMaximumTipPercentage + 1];
        for (NSInteger i = kStartTipPercentage; i <= kMaximumTipPercentage; i++) {
            NSNumber *number = [NSNumber numberWithInteger:i];
            NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:[number stringValue]];
            decimal = [decimal decimalNumberByMultiplyingByPowerOf10:kTipPercentageFactor];
            [tips addObject:decimal];
        }
        tipPercentagesArray = [[NSArray alloc] initWithArray:tips];
        [tips release];
    }
    return tipPercentagesArray;
}

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
     return [self stringForNumberOfSplitsWithDecimalNumber:numberOfSplits_];
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

- (NSString *)stringForNumberOfSplitsWithDecimalNumber:(NSDecimalNumber *)number
{
    NSString *string = nil;
    if ([number integerValue] == 1) {
        string = @"No Split";
    } else {
        string = [NSString stringWithFormat:@"%d People", [number integerValue]];
    }
    return string;
}

- (NSString *)stringForTipPercentageWithDecimalNumber:(NSDecimalNumber *)number
{
    NSString *string = nil;
    if ([number floatValue] == 0.0) {
        string = @"No Tip (Included in Bill)";
    } else {
        string = [self percentageStringForNumber:number];
    }
    return string;
}

- (NSInteger)rowForCurrentNumberOfSplits
{
    NSString *key = [numberOfSplits_ stringValue];
    return [[[Check numberOfSplitsDictionary] objectForKey:key] integerValue];
}

- (NSInteger)rowForCurrentTipPercentage
{
    NSString *key = [tipPercentage_ stringValue];
    return [[[Check tipPercentagesDictionary] objectForKey:key] integerValue];
}

#pragma mark - Private Methods

+ (NSDictionary *)numberOfSplitsDictionary
{
    if (numberOfSplitsDictionary == nil) {
        NSArray *splitsArray = [Check numberOfSplitsArray];
        NSInteger total = [splitsArray count];
        NSMutableDictionary *splitsDictionary = [[NSMutableDictionary alloc] initWithCapacity:total];
        for (NSInteger i = 0; i < total; i++) {
            NSString *key = [[splitsArray objectAtIndex:i] stringValue];
            NSNumber *number = [NSNumber numberWithInteger:i];
            [splitsDictionary setObject:number forKey:key];
        }
        numberOfSplitsDictionary = [[NSDictionary alloc] initWithDictionary:splitsDictionary];
        [splitsDictionary release];
    }
    return numberOfSplitsDictionary;
}

+ (NSDictionary *)tipPercentagesDictionary
{
    if (tipPercentagesDictionary) {
        NSArray *tipArray = [Check tipPercentagesArray];
        NSInteger total = [tipArray count];
        NSMutableDictionary *tipDictionary = [[NSMutableDictionary alloc] initWithCapacity:total];
        for ( NSInteger i = 0; i < total; i++) {
            NSString *key = [[tipArray objectAtIndex:i] stringValue];
            NSNumber *number = [NSNumber numberWithInteger:i];
            [tipDictionary setObject:number forKey:key];
        }
        tipPercentagesDictionary = [[NSDictionary alloc] initWithDictionary:tipDictionary];
        [tipDictionary release];
    }
    return tipPercentagesDictionary;
}

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
