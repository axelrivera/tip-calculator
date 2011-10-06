//
//  AdjustmentValue.h
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdjustmentValue : NSObject

@property (nonatomic, assign) BOOL canChange;
@property (nonatomic, retain) NSNumber *percentage;

- (id)initWithPercentage:(NSNumber *)percentage;
- (id)initWithPercentageValue:(CGFloat)percentageValue;

@end
