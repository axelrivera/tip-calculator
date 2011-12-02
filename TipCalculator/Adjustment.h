//
//  AdjustmentValue.h
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adjustment : NSObject <NSCoding>

@property (nonatomic, readonly) NSDecimalNumber *amount;
@property (nonatomic, readonly) NSDecimalNumber *tip;

- (id)initWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip;
- (id)initWithAmount:(NSDecimalNumber *)amount tipRate:(NSDecimalNumber *)tipRate;

- (NSDecimalNumber *)total;

@end
