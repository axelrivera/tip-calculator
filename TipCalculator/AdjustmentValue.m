//
//  AdjustmentValue.m
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentValue.h"

@implementation AdjustmentValue

@synthesize canChange = canChange_;
@synthesize percentage = percentage_;

- (id)init
{
    self = [super init];
    if (self) {
        self.canChange = YES;
        self.percentage = [NSDecimalNumber zero];
    }
    return self;
}

- (id)initWithPercentage:(NSDecimalNumber *)percentage
{
    self = [self init];
    if (self) {
        CGFloat value = [percentage floatValue];
        NSAssert(value >= 0.0f && value <= 1.0f, @"Invalid Range for Percentage");
        self.percentage = percentage;
    }
    return self;
}

- (id)initWithPercentageValue:(CGFloat)percentageValue
{
    NSNumber *number = [NSNumber numberWithFloat:percentageValue];
    NSDecimalNumber *percentage = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    self = [self initWithPercentage:percentage];
    return self;
}

- (void)dealloc
{
    [percentage_ release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Percentage: %@, Can Change: %d", [percentage_ stringValue], canChange_];
}

@end
