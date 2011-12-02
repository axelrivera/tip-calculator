//
//  Check.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Adjustment.h"
#import "Settings.h"

@interface Check : NSObject <NSCoding>
{
    Settings *settings_;
    NSMutableArray *splitAdjustments_;
}

@property (nonatomic, retain) NSDecimalNumber *numberOfSplits;
@property (nonatomic, retain) NSDecimalNumber *tipPercentage;
@property (nonatomic, retain) NSDecimalNumber *billAmount;
@property (nonatomic, retain, readonly) NSArray *splitAdjustments;

+ (NSArray *)numberOfSplitsArray;
+ (NSArray *)tipPercentagesArray;

- (NSDecimalNumber *)totalTip;
- (NSDecimalNumber *)totalToPay;
- (NSDecimalNumber *)totalPerPerson;
- (NSDecimalNumber *)tipPerPerson;
- (NSDecimalNumber *)billAmountPerPerson;

- (NSString *)stringForNumberOfSplitsWithDecimalNumber:(NSDecimalNumber *)number;
- (NSString *)stringForTipPercentageWithDecimalNumber:(NSDecimalNumber *)number;

- (NSInteger)rowForCurrentNumberOfSplits;
- (NSInteger)rowForCurrentTipPercentage;

- (NSDecimalNumber *)totalAdjustments;
- (NSDecimalNumber *)billAmountAdjustments;
- (NSDecimalNumber *)tipAdjustments;

- (NSDecimalNumber *)totalBalanceAfterAdjustments;
- (NSDecimalNumber *)billAmountBalanceAfterAdjustments;
- (NSDecimalNumber *)tipBalanceAfterAdjustments;

- (NSDecimalNumber *)totalBalancePerPersonAfterAdjustments;
- (NSDecimalNumber *)billAmountBalancePerPersonAfterAdjustments;
- (NSDecimalNumber *)tipBalancePerPersonAfterAdjustments;

- (NSDecimalNumber *)numberOfSplitsLeftAfterAdjustment;

- (BOOL)canAddOneMoreAdjusment;
- (BOOL)currentBalanceEqualToZero;
- (BOOL)currentBalanceIsNegative;
- (BOOL)currentBalanceEqualToZeroOrNegative;

- (NSDecimalNumber *)decimalNumberOfSplitAdjustments;
- (void)addSplitAdjustment:(Adjustment *)adjustment;
- (void)removeSplitAdjustmentAtIndex:(NSInteger)index;
- (void)removeAllSplitAdjustments;

@end
