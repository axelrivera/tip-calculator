//
//  CheckData.h
//  TipCalculator
//
//  Created by arn on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Check.h"

@interface CheckData : NSObject

@property (nonatomic, retain) Check *currentCheck;

+ (CheckData *)sharedCheckData;

@end
