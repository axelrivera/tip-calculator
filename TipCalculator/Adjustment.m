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

@synthesize amount = amount_;
@synthesize tip = tip_;

- (id)initWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip
{
    self = [super init];
    if (self) {
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

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];  // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	if (self) {
		[self setAmount:[decoder decodeObjectForKey:@"adjustmentAmount"]];
		[self setTip:[decoder decodeObjectForKey:@"adjustmentTip"]];
		
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:amount_ forKey:@"adjustmentAmount"];
	[encoder encodeObject:tip_ forKey:@"adjustmentTip"];
	
}


- (void)dealloc
{
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
