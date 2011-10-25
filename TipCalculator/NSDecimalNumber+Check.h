//
//  NSDecimalNumber+Modulo.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Check)

- (NSDecimalNumber *)decimalCurrencyByAdding:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyBySubtracting:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByMultiplyingBy:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalCurrencyByDividingBy:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalNumberByModuloDivision:(NSDecimalNumber *)decimalNumber;

- (NSString *)currencyString;
- (NSString *)percentString;

@end
