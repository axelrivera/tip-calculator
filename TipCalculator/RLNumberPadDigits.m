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

static NSNumberFormatter *digitsFormatter_;

@interface RLNumberPadDigits (Private)

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimalNumber;
- (void)setEnteredDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber;

- (void)addNumberToDigits:(NSString *)string;
- (void)addNumberToDecimals:(NSString *)string;

- (void)addPaddingToDecimals;

+ (NSNumberFormatter *)digitsFormatter;

@end

@implementation RLNumberPadDigits

@synthesize enteredDigits = enteredDigits_;
@synthesize enteredDecimals = enteredDecimals_;
@synthesize useDecimalSeparator = useDecimalSeparator_;

- (id)init
{
    self = [super init];
    if (self) {
        self.enteredDigits = @"0";
        self.enteredDecimals = @"";
        self.useDecimalSeparator = NO;
    }
    return self;
}

- (id)initWithDigits:(NSString *)digits andDecimals:(NSString *)decimals
{
    self = [self init];
    if (self) {
        self.enteredDigits = digits;
        self.enteredDecimals = decimals;
    }
    return self;
}

- (id)initWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    self = [self init];
    if (self) {
        [self setDigitsAndDecimalsWithDecimalNumber:decimalNumber];
    }
    return self;
}

- (void)dealloc
{
    [enteredDigits_ release];
    [enteredDecimals_ release];
    [super dealloc];
}

#pragma mark - Custom Methods

- (void)setDigitsAndDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *dollars = [NSDecimalNumber zero];
    NSDecimalNumber *cents = [NSDecimalNumber zero];
    NSComparisonResult decimalCompare = [decimalNumber compare:[NSDecimalNumber zero]];
    if (decimalCompare != NSOrderedSame) {
        NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                  scale:0
                                                                                       raiseOnExactness:NO
                                                                                        raiseOnOverflow:NO
                                                                                       raiseOnUnderflow:NO
                                                                                    raiseOnDivideByZero:NO];
        dollars = [decimalNumber decimalNumberByRoundingAccordingToBehavior:behavior];
        cents = [decimalNumber decimalNumberBySubtracting:dollars];
        cents = [cents decimalNumberByMultiplyingByPowerOf10:abs(kCurrencyScale)];
    }
	[self setEnteredDigitsWithDecimalNumber:dollars];
    [self setEnteredDecimalsWithDecimalNumber:cents];
}

- (void)resetDigitsAndDecimals
{
    self.enteredDigits = @"0";
    self.enteredDecimals = @"";
    useDecimalSeparator_ = NO;
}

- (void)addNumber:(NSString *)string
{	
	if ([string isEqualToString:@"0"] && [self length] == 0) {
		return;
	}
    
    if (![string isEqualToString:@""] &&
		useDecimalSeparator_ == YES &&
		[enteredDecimals_ length] >= abs(kCurrencyScale))
	{
        return;
    }
    
    if (useDecimalSeparator_ == NO &&
		[string isEqualToString:@"."])
	{
        useDecimalSeparator_ = YES;
    }
	
	// Check the length of the string
	if ([string length] > 0) {
        if (!useDecimalSeparator_) {
            [self addNumberToDigits:string];
        } else {
            [self addNumberToDecimals:string];
        }
	}	
}

- (NSUInteger)length
{
    return [enteredDigits_ length] + [enteredDecimals_ length];
}

- (void)validateAndFixDecimalSeparator
{
	NSString *numberStr = [[NSArray arrayWithObjects:enteredDigits_, enteredDecimals_, nil] componentsJoinedByString:@"."];
	NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:numberStr];
	NSComparisonResult compareNumber = [decimalNumber compare:[NSDecimalNumber zero]];
	if (compareNumber == NSOrderedSame) {
		[self resetDigitsAndDecimals];
	} else {
		useDecimalSeparator_ = YES;
		[self addPaddingToDecimals];
	}
}

- (NSDecimalNumber *)decimalNumber
{
    NSMutableString *decimalStr = [NSMutableString string];
	[decimalStr appendString:enteredDigits_];
    if (useDecimalSeparator_ && ![enteredDecimals_ isEqualToString:@""]) {
        [decimalStr appendFormat:@".%@", enteredDecimals_];
    }
    return [NSDecimalNumber decimalNumberWithString:decimalStr];
}

- (NSString *)stringValue
{
    NSNumberFormatter *formatter = [[NSDecimalNumber currencyFormatter] copy];
    
    NSString *dollarsStr = enteredDigits_;
    NSString *centsStr  = enteredDecimals_;
    
    NSString *string = [[NSArray arrayWithObjects:dollarsStr, centsStr, nil] componentsJoinedByString:@"."];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:string];
    
    formatter.minimumFractionDigits = [centsStr length];
    formatter.maximumFractionDigits = [centsStr length];
    
    if ([centsStr length] == 0 && useDecimalSeparator_) {
        formatter.alwaysShowsDecimalSeparator = YES;
    } else {
        formatter.alwaysShowsDecimalSeparator = NO;
    }
    
    NSString *decimalStr = [formatter stringFromNumber:decimalNumber];
    [formatter release];
    
    return decimalStr;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Digits: %@, Decimals: %@, Number: %@, String: %@",
            enteredDigits_,
            enteredDecimals_,
            [self decimalNumber],
            [self stringValue]];
}

#pragma mark - Private Methods

- (void)setEnteredDigitsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSString *string = @"0";
    if (![decimalNumber isEqualToZero]) {
        string = [decimalNumber stringValue];
    }
    self.enteredDigits = string;
}

- (void)setEnteredDecimalsWithDecimalNumber:(NSDecimalNumber *)decimalNumber
{
    NSString *string = @"";
    if (![decimalNumber isEqualToZero]) {
        string = [decimalNumber stringValue];
    }
    self.enteredDecimals = string;
}

- (void)addNumberToDigits:(NSString *)string
{
    NSMutableString *digits = nil;
	if ([enteredDigits_ isEqualToString:@"0"]) {
		digits = [NSMutableString stringWithCapacity:0];
	} else {
		digits = [NSMutableString stringWithString:enteredDigits_];
	}
    [digits appendString:string];
    self.enteredDigits = digits;
}

- (void)addNumberToDecimals:(NSString *)string
{
    if ([string isEqualToString:@"."]) {
        return;
    }
    NSMutableString *decimals = [NSMutableString stringWithString:enteredDecimals_];
    [decimals appendString:string];
    self.enteredDecimals = decimals;
}

- (void)addPaddingToDecimals
{
	if ([enteredDigits_ length] > 0) {
		self.enteredDecimals = [enteredDecimals_ stringByPaddingToLength:abs(kCurrencyScale) withString:@"0" startingAtIndex:0];
	}
}

+ (NSNumberFormatter *)digitsFormatter
{
    if (digitsFormatter_ == nil) {
        digitsFormatter_ = [[NSNumberFormatter alloc] init];
        digitsFormatter_.numberStyle = NSNumberFormatterDecimalStyle;
        digitsFormatter_.maximumFractionDigits = 0;
    }
    return digitsFormatter_;
}

@end
