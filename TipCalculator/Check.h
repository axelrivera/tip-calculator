//
//  Check.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Check : NSObject
{
    NSMutableArray *splitAdjustments_;
}

@property (nonatomic, retain) NSDecimalNumber *numberOfSplits;
@property (nonatomic, retain) NSDecimalNumber *tipPercentage;
@property (nonatomic, retain) NSDecimalNumber *checkAmount;
@property (nonatomic, retain, readonly) NSArray *splitAdjustments;

+ (NSArray *)numberOfSplitsArray;
+ (NSArray *)tipPercentagesArray;

- (NSDecimalNumber *)totalTip;
- (NSDecimalNumber *)totalToPay;
- (NSDecimalNumber *)totalPerPerson;

- (NSString *)stringForNumberOfSplits;
- (NSString *)stringForTipPercentage;
- (NSString *)stringForCheckAmount;
- (NSString *)stringForTotalTip;
- (NSString *)stringForTotalToPay;
- (NSString *)stringForTotalPerPerson;

- (NSString *)stringForNumberOfSplitsWithDecimalNumber:(NSDecimalNumber *)number;
- (NSString *)stringForTipPercentageWithDecimalNumber:(NSDecimalNumber *)number;

- (NSInteger)rowForCurrentNumberOfSplits;
- (NSInteger)rowForCurrentTipPercentage;

- (NSArray *)adjustmentsWithCanBeChangedValue:(BOOL)value;
- (NSDecimalNumber *)adjustmentsSumWithCanBeChangedValue:(BOOL)value;

- (void)splitAdjustmentsEvenly;
- (void)setAdjustmentAtIndex:(NSInteger)index withPercentage:(NSDecimalNumber *)percentage canChange:(BOOL)canChange;

@end
