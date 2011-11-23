//
//  UIColor+Chalk.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/22/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "UIColor+TipCalculator.h"

@implementation UIColor (TipCalculator)

+ (UIColor *)selectedViewNormalColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)selectedViewHighlightedColor
{
    return [UIColor colorWithRed:56.0/255.00 green:103.0/255.0 blue:173.0/255.0 alpha:1.0];
}

+ (UIColor *)purpleChalkColor
{
    return [UIColor colorWithRed:88.0/255.0 green:90.0/255.0 blue:165.0/255.0 alpha:1.0];
}

+ (UIColor *)greenBoardColor
{
    return [UIColor colorWithRed:2.0/255.0 green:92.0/255.0 blue:79.0/255.0 alpha:1.0];
}

@end
