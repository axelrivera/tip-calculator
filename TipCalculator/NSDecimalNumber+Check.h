//
//  NSDecimalNumber+Modulo.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Check)

+ (NSNumberFormatter *)currencyFormatter;
+ (NSNumberFormatter *)percentFormatter;
+ (NSNumberFormatter *)taxFormatter;

- (NSDecimalNumber *)decimalCurrencyByAdding:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyBySubtracting:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByMultiplyingBy:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByDividingBy:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByDividingBy:(NSDecimalNumber *)decimalNumber rounding:(NSRoundingMode)rounding;
- (NSDecimalNumber *)decimalNumberByModuloDivision:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByRoundingDown;
- (NSDecimalNumber *)decimalCurrencyByRoundingUp;

- (BOOL)isEqualToZero;

- (NSString *)currencyString;
- (NSString *)percentString;
- (NSString *)taxString;

@end
