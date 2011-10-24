//
//  CheckHelper.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckHelper.h"
#import "NSDecimalNumber+Check.h"

@implementation CheckHelper

+ (NSDecimalNumber *)calculateTipWithAmount:(NSDecimalNumber *)amount andRate:(NSDecimalNumber *)rate
{
    NSDecimalNumber *tip = [amount decimalCurrencyByMultiplyingBy:rate];
    return tip;
}

+ (NSDecimalNumber *)calculateTotalWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip
{
    NSDecimalNumber *total = [amount decimalCurrencyByAdding:tip];
    return total;
}

+ (NSDecimalNumber *)calculatePersonAmount:(NSDecimalNumber *)amount withSplit:(NSDecimalNumber *)split
{
    return [amount decimalCurrencyByDividingBy:split];
}

@end
