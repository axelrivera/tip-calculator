//
//  RLNumberPadFormatter.m
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RLNumberPadDigits.h"
#import "NSDecimalNumber+Check.h"

#define kCurrencyScale -2
#define kMaxDigits 9

@implementation RLNumberPadDigits

@synthesize enteredDigits = enteredDigits_;

- (id)init
{
    self = [super init];
    if (self) {
        self.enteredDigits = @"";
    }
    return self;
}

- (id)initWithDigits:(NSString *)digits
{
    self = [self init];
    if (self) {
        self.enteredDigits = digits;
    }
    return self;
}

- (id)initWithDecimalNumber:(NSDecimalNumber *)decimal
{
    self = [self init];
    if (self) {
        [self setEnteredDigitsWithDecimalNumber:decimal];
    }
    return self;
}

- (void)dealloc
{
    [enteredDigits_ release];
    [super dealloc];
}

#pragma mark - Custom Methods

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimal
{
    NSString *string = @"";
    NSComparisonResult decimalCompare = [decimal compare:[NSDecimalNumber zero]];
    if (decimalCompare != NSOrderedSame) {
        NSDecimalNumber *digits = [decimal decimalNumberByMultiplyingByPowerOf10:abs(kCurrencyScale)];
        string = [digits stringValue];
    }
    self.enteredDigits = string;
}

- (void)addDigit:(NSString *)string
{
   	//NSLog(@"Entered Digits (change start): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change start): %@", self.currentPrice);
	
	if ([string isEqualToString:@"0"] && [enteredDigits_ length] == 0) {
		return;
	}
    
    // Ignore Decimal Point for Now!!
    if ([string isEqualToString:@"."]) {
        return;
    }
	
	// Check the length of the string
	if ([string length] > 0) {
        if ([enteredDigits_ length] + 1 <= kMaxDigits) {
            self.enteredDigits = [enteredDigits_ stringByAppendingFormat:@"%d", [string integerValue]];
        }
	} else {
		// This is a backspace
		NSUInteger len = [enteredDigits_ length];
		if (len > 1) {
			self.enteredDigits = [enteredDigits_ substringWithRange:NSMakeRange(0, len - 1)];
		} else {
			self.enteredDigits = @"";
		}
	}	
}

- (NSDecimalNumber *)decimalNumberForEnteredDigits
{
	NSDecimalNumber *number = nil;
	if (![enteredDigits_ isEqualToString:@""]) {
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:enteredDigits_];
		number = [decimal decimalNumberByMultiplyingByPowerOf10:kCurrencyScale];
	} else {
		number = [NSDecimalNumber zero];
	}
    return number;
}

- (NSString *)stringForEnteredDigits
{
    return [[self decimalNumberForEnteredDigits] currencyString];
}

@end
