//
//  Check.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Check : NSObject

@property (nonatomic, copy) NSDecimalNumber *numberOfSplits;
@property (nonatomic, copy) NSDecimalNumber *tipPercentage;
@property (nonatomic, copy) NSDecimalNumber *checkAmount;

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

@end
