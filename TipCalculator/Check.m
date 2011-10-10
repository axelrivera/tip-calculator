//
//  Check.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Check.h"
#import "AdjustmentValue.h"

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

- (void)dealloc
{
    [numberOfSplits_ release];
    [tipPercentage_ release];
    [checkAmount_ release];
    [splitAdjustments_ release];
    [super dealloc]; 
}

#pragma mark - Custom Getters and Setters

- (NSArray *)splitAdjustments
{
    return splitAdjustments_;
}

- (void)setSplitAdjustments:(NSArray *)splitAdjustments
{
    [splitAdjustments_ autorelease];
    splitAdjustments_ = [[NSMutableArray alloc] initWithArray:splitAdjustments];
}

#pragma mark - Custom Methods

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
        string = @"No Tip (Included)";
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
    NSDecimalNumber *decimal = [tipPercentage_ decimalNumberByMultiplyingByPowerOf10:abs(kTipPercentageFactor)];
    NSString *key = [decimal stringValue];
    return [[[Check tipPercentagesDictionary] objectForKey:key] integerValue];
}

- (NSArray *)adjustmentsWithCanBeChangedValue:(BOOL)value
{
    NSInteger totalAdjustments = [splitAdjustments_ count];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSInteger i = 0; i < totalAdjustments; i++) {
        AdjustmentValue *adjustment = [splitAdjustments_ objectAtIndex:i];
        if (adjustment.canChange == value) {
            [array addObject:adjustment];
        }
    }
    return array;
}

- (NSDecimalNumber *)adjustmentsSumWithCanBeChangedValue:(BOOL)value
{
    NSArray *adjustmentsArray = [self adjustmentsWithCanBeChangedValue:value];
    NSInteger adjustmentsTotal = [adjustmentsArray count];
    NSDecimalNumber *sumTotal = [NSDecimalNumber zero];
    for (NSInteger i = 0; i < adjustmentsTotal; i++) {
        AdjustmentValue *adjustment = [adjustmentsArray objectAtIndex:i];
        sumTotal = [sumTotal decimalNumberByAdding:adjustment.percentage];
    }
    return sumTotal;
}

- (void)splitAdjustmentsEvenly
{
    NSInteger total = [numberOfSplits_ integerValue];
    if (total == 1) {
        AdjustmentValue *adjustment = [[AdjustmentValue alloc] initWithPercentageValue:1.0];
        adjustment.canChange = NO;
        NSArray *array = [[NSArray alloc] initWithObjects:adjustment, nil];
        [self setSplitAdjustments:array];
        [array release];
    } else {
        NSDecimalNumber *fullValue = [NSDecimalNumber one];
        NSDecimalNumber *split = [fullValue decimalNumberByDividingBy:numberOfSplits_];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:total];
        for (NSInteger i = 0; i < total; i++) {
            AdjustmentValue *adjustment = [[[AdjustmentValue alloc] initWithPercentage:split] autorelease];
            [array addObject:adjustment];
        }
        [self setSplitAdjustments:array];
        [array release];
    }
}

- (void)setAdjustmentAtIndex:(NSInteger)index withPercentage:(NSDecimalNumber *)percentage canChange:(BOOL)canChange
{
    AdjustmentValue *currentAdjustment = [[AdjustmentValue alloc] initWithPercentage:percentage];
    currentAdjustment.canChange = NO;
    [splitAdjustments_ replaceObjectAtIndex:index withObject:currentAdjustment];
    [currentAdjustment release];
    
    NSDecimalNumber *validSum = [self adjustmentsSumWithCanBeChangedValue:YES];
    NSDecimalNumber *dirtySum = [[NSDecimalNumber one] decimalNumberBySubtracting:validSum];
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
    if (tipPercentagesDictionary == nil) {
        NSArray *tipArray = [Check tipPercentagesArray];
        NSInteger total = [tipArray count];
        NSMutableDictionary *tipDictionary = [[NSMutableDictionary alloc] initWithCapacity:total];
        for ( NSInteger i = 0; i < total; i++) {
            NSDecimalNumber *decimal = [tipArray objectAtIndex:i];
            NSString *key = [[decimal decimalNumberByMultiplyingByPowerOf10:abs(kTipPercentageFactor)] stringValue];
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
