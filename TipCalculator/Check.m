//
//  Check.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Check.h"
#import "Adjustment.h"
#import "CheckHelper.h"
#import "NSDecimalNumber+Check.h"

#define kStartNumberOfSplits 1
#define kMaximumNumberOfSplits 50

#define kStartTipPercentage 0
#define kMaximumTipPercentage 50
#define kTipPercentageFactor -2

#define kDefaultNumberOfSplits @"1"
#define kDefaultTipPercentage  @"0.15"
#define kDefaultBillAmount @"0.00"

static NSArray *numberOfSplitsArray;
static NSArray *tipPercentagesArray;
static NSDictionary *numberOfSplitsDictionary;
static NSDictionary *tipPercentagesDictionary;

@interface Check (Private)

+ (NSDictionary *)numberOfSplitsDictionary;
+ (NSDictionary *)tipPercentagesDictionary;

- (NSInteger)numberOfAdjustmentsPlusOne;

- (void)setSplitAdjustments:(NSMutableArray *)splitAdjustments;
- (NSString *)percentSuffixForInteger:(NSInteger)integerValue;

@end

@implementation Check

@synthesize numberOfSplits = numberOfSplits_;
@synthesize tipPercentage = tipPercentage_;
@synthesize billAmount = billAmount_;

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
        settings_ = [Settings sharedSettings];
        self.numberOfSplits = [NSDecimalNumber decimalNumberWithString:kDefaultNumberOfSplits];
        self.tipPercentage = [NSDecimalNumber decimalNumberWithString:kDefaultTipPercentage];
        self.billAmount = [NSDecimalNumber decimalNumberWithString:kDefaultBillAmount];
        [self setSplitAdjustments:[NSMutableArray arrayWithCapacity:0]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];  // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	if (self) {
		self.numberOfSplits = [decoder decodeObjectForKey:@"checkNumberOfSplits"];
		self.tipPercentage = [decoder decodeObjectForKey:@"checkTipPercentage"];
		self.billAmount = [decoder decodeObjectForKey:@"checkBillAmount"];
		splitAdjustments_ = [[decoder decodeObjectForKey:@"checkSplitAdjustments"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:numberOfSplits_ forKey:@"checkNumberOfSplits"];
	[encoder encodeObject:tipPercentage_ forKey:@"checkTipPercentage"];
	[encoder encodeObject:billAmount_ forKey:@"checkBillAmount"];
	[encoder encodeObject:splitAdjustments_ forKey:@"checkSplitAdjustments"];
}

- (void)dealloc
{
    [numberOfSplits_ release];
    [tipPercentage_ release];
    [billAmount_ release];
    [splitAdjustments_ release];
    [super dealloc]; 
}

#pragma mark - Custom Methods

- (NSDecimalNumber *)totalTip
{
    return [CheckHelper calculateTipWithAmount:billAmount_ andRate:tipPercentage_];
}

- (NSDecimalNumber *)totalToPay
{
    return [CheckHelper calculateTotalWithAmount:billAmount_ andTip:[self totalTip]];
}

- (NSDecimalNumber *)totalPerPerson
{
    return [CheckHelper calculatePersonAmount:[self totalToPay] withSplit:numberOfSplits_];
}

- (NSDecimalNumber *)tipPerPerson
{
    return [CheckHelper calculatePersonAmount:[self totalTip] withSplit:numberOfSplits_];
}

- (NSDecimalNumber *)billAmountPerPerson
{
    return [CheckHelper calculatePersonAmount:billAmount_ withSplit:numberOfSplits_];
}

- (NSString *)stringForNumberOfSplitsWithDecimalNumber:(NSDecimalNumber *)number
{
    NSString *string = nil;
    if ([number compare:[NSDecimalNumber one]] == NSOrderedSame) {
        string = @"No Split";
    } else {
        string = [NSString stringWithFormat:@"%d People", [number integerValue]];
    }
    return string;
}

- (NSString *)stringForTipPercentageWithDecimalNumber:(NSDecimalNumber *)number picker:(BOOL)picker
{
	NSInteger integerValue = [[number decimalNumberByMultiplyingByPowerOf10:2] integerValue];
	NSString *suffix = nil;
	
	if (picker) {
		if (integerValue == 5 ||
			integerValue == 10 ||
			integerValue == 15 ||
			integerValue == 20 ||
			integerValue == 25)
		{
			suffix = [self percentSuffixForInteger:integerValue];
		} else {
			suffix = @"";
		}
	} else {
		suffix = [self percentSuffixForInteger:integerValue];
	}
	
    NSString *string = nil;
    if ([number compare:[NSDecimalNumber zero]] == NSOrderedSame) {
        string = [NSString stringWithFormat:@"%@ (Included)", [number percentString]];
    } else {
        string = [NSString stringWithFormat:@"%@%@", [number percentString], suffix];
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



- (NSDecimalNumber *)totalAdjustments
{
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    if ([splitAdjustments_ count] > 0) {
        for (Adjustment *adjustment in splitAdjustments_) {
            sum = [sum decimalCurrencyByAdding:[adjustment total]];
        }
    }
    return sum;
}

- (NSDecimalNumber *)billAmountAdjustments
{
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    if ([splitAdjustments_ count] > 0) {
        for (Adjustment *adjustment in splitAdjustments_) {
            sum = [sum decimalCurrencyByAdding:adjustment.amount];
        }
    }
    return sum;
}

- (NSDecimalNumber *)tipAdjustments
{
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    if ([splitAdjustments_ count] > 0) {
        for (Adjustment *adjustment in splitAdjustments_) {
            sum = [sum decimalCurrencyByAdding:adjustment.tip];
        }
    }
    return sum;
}

- (NSDecimalNumber *)totalBalanceAfterAdjustments
{
    NSDecimalNumber *adjustments = [self totalAdjustments];
    NSDecimalNumber *balance = [[self totalToPay] decimalCurrencyBySubtracting:adjustments];
    return balance;   
}

- (NSDecimalNumber *)billAmountBalanceAfterAdjustments
{
    NSDecimalNumber *adjustments = [self billAmountAdjustments];
    NSDecimalNumber *balance = [billAmount_ decimalCurrencyBySubtracting:adjustments];
    return balance;
}

- (NSDecimalNumber *)tipBalanceAfterAdjustments
{
    NSDecimalNumber *adjusments = [self tipAdjustments];
    NSDecimalNumber *balance = [[self totalTip] decimalCurrencyBySubtracting:adjusments];
    return balance;
}

- (NSDecimalNumber *)totalBalancePerPersonAfterAdjustments
{
    NSDecimalNumber *numberOfPeopleLeft = [self numberOfSplitsLeftAfterAdjustment];
    NSDecimalNumber *totalBalance = [self totalBalanceAfterAdjustments];
    return [CheckHelper calculatePersonAmount:totalBalance withSplit:numberOfPeopleLeft];
}

- (NSDecimalNumber *)billAmountBalancePerPersonAfterAdjustments
{
    NSDecimalNumber *numberOfPeopleLeft = [self numberOfSplitsLeftAfterAdjustment];
    NSDecimalNumber *billBalance = [self billAmountBalanceAfterAdjustments];
    return [CheckHelper calculatePersonAmount:billBalance withSplit:numberOfPeopleLeft];
}

- (NSDecimalNumber *)tipBalancePerPersonAfterAdjustments
{
    NSDecimalNumber *numberOfPeopleLeft = [self numberOfSplitsLeftAfterAdjustment];
    NSDecimalNumber *tipBalance = [self tipBalanceAfterAdjustments];
    return [CheckHelper calculatePersonAmount:tipBalance withSplit:numberOfPeopleLeft];
}

- (NSDecimalNumber *)numberOfSplitsLeftAfterAdjustment
{
    return [numberOfSplits_ decimalNumberBySubtracting:[self decimalNumberOfSplitAdjustments]];
}

- (BOOL)canAddOneMoreAdjusment
{
    if ([self numberOfAdjustmentsPlusOne] >= [numberOfSplits_ integerValue]) {
        return NO;
    }
    return YES;
}

- (BOOL)currentBalanceEqualToZero
{
	NSDecimalNumber *currentBalance = [self totalBalanceAfterAdjustments];
	NSComparisonResult compareCurrentBalance = [currentBalance compare:[NSDecimalNumber zero]];
	if (compareCurrentBalance == NSOrderedSame) {
        return YES;
    }
    return NO ;
}

- (BOOL)currentBalanceIsNegative
{
	NSDecimalNumber *currentBalance = [self totalBalanceAfterAdjustments];
	NSComparisonResult compareCurrentBalance = [currentBalance compare:[NSDecimalNumber zero]];
	if (compareCurrentBalance == NSOrderedAscending) {
        return YES;
    }
    return NO ;
}

- (BOOL)currentBalanceEqualToZeroOrNegative
{
	if ([self currentBalanceEqualToZero] || [self currentBalanceIsNegative]) {
        return YES;
    }
    return NO ;
}

- (NSDecimalNumber *)decimalNumberOfSplitAdjustments
{
    NSNumber *number = [NSNumber numberWithInteger:[splitAdjustments_ count]];
    return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
}

- (void)addSplitAdjustment:(Adjustment *)adjustment
{
    [splitAdjustments_ addObject:adjustment];
}

- (void)removeSplitAdjustmentAtIndex:(NSInteger)index
{
    [splitAdjustments_ removeObjectAtIndex:index];
}

- (void)removeAllSplitAdjustments
{
    [splitAdjustments_ removeAllObjects];
}

#pragma mark - Custom Setters and Getters

- (NSArray *)splitAdjustments
{
    return splitAdjustments_;
}

- (void)setSplitAdjustments:(NSMutableArray *)splitAdjustments
{
	if (splitAdjustments_ != nil) {
		[splitAdjustments_ release];
	}
    splitAdjustments_ = [splitAdjustments retain];
}

#pragma mark - Private Methods

- (NSInteger)numberOfAdjustmentsPlusOne
{
    return [splitAdjustments_ count] + 1;
}

- (NSString *)percentSuffixForInteger:(NSInteger)integerValue
{
	NSString *suffix = nil;
	if (integerValue >= 0 && integerValue <= 5) {
		suffix = @" (Poor)";
	} else if (integerValue >= 6 && integerValue <= 10) {
		suffix = @" (Fair)";
	} else if (integerValue >= 11 && integerValue <= 15) {
		suffix = @" (Good)";
	} else if (integerValue >= 16 && integerValue <= 20) {
		suffix = @" (Great)";
	} else if (integerValue >= 21) {
		suffix = @" (Super)";
	} else {
		suffix = @"";
	}
	return suffix;
}

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

@end
