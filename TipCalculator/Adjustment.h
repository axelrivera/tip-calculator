//
//  AdjustmentValue.h
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adjustment : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain, readonly) NSDecimalNumber *totalPerPerson;
@property (nonatomic, retain, readonly) NSDecimalNumber *billAmountPerPerson;
@property (nonatomic, retain, readonly) NSDecimalNumber *tipPerPerson;
@property (nonatomic, assign) BOOL canChange;

- (id)initWithTotal:(NSDecimalNumber *)total billAmount:(NSDecimalNumber *)billAmount tip:(NSDecimalNumber *)tip;
- (void)replaceTotal:(NSDecimalNumber *)total billAmount:(NSDecimalNumber *)billAmount tip:(NSDecimalNumber *)tip;

@end
