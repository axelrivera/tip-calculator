//
//  CheckHelper.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckHelper : NSObject

+ (NSDecimalNumber *)calculateTipWithAmount:(NSDecimalNumber *)amount andRate:(NSDecimalNumber *)rate;
+ (NSDecimalNumber *)calculateTotalWithAmount:(NSDecimalNumber *)amount andTip:(NSDecimalNumber *)tip;
+ (NSDecimalNumber *)calculatePersonAmount:(NSDecimalNumber *)amount withSplit:(NSDecimalNumber *)split;

@end
