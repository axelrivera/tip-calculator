//
//  AdjustmentValue.m
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Adjustment.h"
#import "CheckHelper.h"
#import "NSDecimalNumber+Check.h"

@interface Adjustment (Private)

- (void)setAmount:(NSDecimalNumber *)amount;
- (void)setTip:(NSDecimalNumber *)tip;

@end

@implementation Adjustment

@synthesize name = name_;
@synthesize amount = amount_;
@synthesize tip = tip_;

- (id)initWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip
{
    self = [super init];
    if (self) {
        self.name = [NSString stringWithString:@""];
        [self setAmount:amount];
        [self setTip:tip];
    }
    return self;
}

- (id)initWithAmount:(NSDecimalNumber *)amount tipRate:(NSDecimalNumber *)tipRate
{
    NSDecimalNumber *tip = [CheckHelper calculateTipWithAmount:amount andRate:tipRate];
    self = [self initWithAmount:amount andTip:tip];
    return self;
}

- (void)dealloc
{
    [name_ release];
    [amount_ release];
    [tip_ release];
    [super dealloc];
}

#pragma mark - Custom Methods

- (NSDecimalNumber *)total
{
    return [amount_ decimalCurrencyByAdding:tip_];
}

#pragma mark - Private Methods

- (void)setAmount:(NSDecimalNumber *)amount
{
    [amount_ autorelease];
    amount_ = [amount copy];
}
                                
- (void)setTip:(NSDecimalNumber *)tip
{
    [tip_ autorelease];
    tip_ = [tip copy];
}

@end
