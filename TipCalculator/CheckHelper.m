//
//  CheckHelper.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckHelper.h"
#import "NSDecimalNumber+Check.h"
#import "Settings.h"

@implementation CheckHelper

+ (NSDecimalNumber *)calculateTipWithAmount:(NSDecimalNumber *)amount andRate:(NSDecimalNumber *)rate
{
    Settings *settings = [Settings sharedSettings];
    NSDecimalNumber *newAmount = amount;
    if (!settings.tipOnTax) {
        NSDecimalNumber *divisor = [[NSDecimalNumber one] decimalNumberByAdding:[settings taxRatePercentage]];
        newAmount = [newAmount decimalCurrencyByDividingBy:divisor];
    }
    
    NSDecimalNumber *tip = [newAmount decimalCurrencyByMultiplyingBy:rate];
    
    if (settings.rounding == RoundingTypeNone) {
        return tip;
    }
    
    if (settings.rounding == RoundingTypeTipUp) {
        tip = [tip decimalCurrencyByRoundingUp];
	} else if (settings.rounding == RoundingTypeTipDown) {
		tip = [tip decimalCurrencyByRoundingDown];
    } else {
        NSDecimalNumber *totalBill = [CheckHelper calculateTotalWithAmount:amount andTip:tip];
		NSDecimalNumber *newTotal = nil;
		if (settings.rounding == RoundingTypeTotalUp) {
			newTotal = [totalBill decimalCurrencyByRoundingUp];
		} else {
			newTotal = [totalBill decimalCurrencyByRoundingDown];
		}
        NSDecimalNumber *totalOffset = [totalBill decimalCurrencyBySubtracting:newTotal];
        tip = [tip decimalCurrencyBySubtracting:totalOffset];
    }
    return tip;
}

+ (NSDecimalNumber *)calculateTotalWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip
{
    NSDecimalNumber *total = [amount decimalCurrencyByAdding:tip];
    return total;
}

+ (NSDecimalNumber *)calculatePersonAmount:(NSDecimalNumber *)amount withSplit:(NSDecimalNumber *)split
{
    return [amount decimalCurrencyByDividingBy:split rounding:NSRoundUp];
}

@end
