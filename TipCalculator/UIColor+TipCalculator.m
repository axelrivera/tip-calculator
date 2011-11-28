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

+ (UIColor *)brightYellowChalkColor
{
	return [UIColor colorWithRed:251.0/255.0 green:183.0/255.0 blue:24.0/255.0 alpha:1.0];
}

+ (UIColor *)yellowChalkColor
{
	return [UIColor colorWithRed:251.0/255.0 green:216.0/255.0 blue:2.0/255.0 alpha:1.0];
}

+ (UIColor *)greenBoardColor
{
    return [UIColor colorWithRed:3.0/255.0 green:91.0/255.0 blue:77.0/255.0 alpha:1.0];
}

+ (UIColor *)lightGreenBoardColor
{
	return [UIColor colorWithRed:59.0/255.0 green:131.0/255.0 blue:120.0/255.0 alpha:1.0];
}

@end
