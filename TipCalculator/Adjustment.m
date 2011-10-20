//
//  AdjustmentValue.m
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Adjustment.h"

@interface Adjustment (Private)

- (void)setTotalPerPerson:(NSDecimalNumber *)number;
- (void)setBillAmountPerPerson:(NSDecimalNumber *)number;
- (void)setTipPerPerson:(NSDecimalNumber *)number;

@end

@implementation Adjustment

@synthesize name = name_;
@synthesize totalPerPerson = totalPerPerson_;
@synthesize billAmountPerPerson = billAmountPerPerson_;
@synthesize tipPerPerson = tipPerPerson_;
@synthesize canChange = canChange_;

- (id)init
{
    self = [super init];
    if (self) {
        name_ = [[NSString alloc] initWithString:@""];
        canChange_ = YES;
    }
    return self;
}

- (void)dealloc
{
    [name_ release];
    [totalPerPerson_ release];
    [billAmountPerPerson_ release];
    [tipPerPerson_ release];
    [super dealloc];
}

#pragma mark - Private Methods

- (void)setTotalPerPerson:(NSDecimalNumber *)number
{
    [totalPerPerson_ autorelease];
    totalPerPerson_ = [number retain];
}

- (void)setBillAmountPerPerson:(NSDecimalNumber *)number
{
    [billAmountPerPerson_ autorelease];
    billAmountPerPerson_ = [number retain];
}

- (void)setTipPerPerson:(NSDecimalNumber *)number
{
    [tipPerPerson_ autorelease];
    tipPerPerson_ = [number retain];
}

@end
