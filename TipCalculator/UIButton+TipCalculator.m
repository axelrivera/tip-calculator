//
//  UIButton+TipCalculator.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/23/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "UIButton+TipCalculator.h"
#import "UIColor+TipCalculator.h"

@implementation UIButton (TipCalculator)

+ (UIButton *)whiteButtonAtPoint:(CGPoint)point
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(point.x, point.y, 75.0, 30.0);
    [button setBackgroundImage:[UIImage imageNamed:@"white_button_bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow_button_bg.png"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor purpleChalkColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

+ (UIButton *)orangeButtonAtPoint:(CGPoint)point
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(point.x, point.y, 75.0, 30.0);
    [button setBackgroundImage:[UIImage imageNamed:@"orange_button_bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"yellow_button_bg.png"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15];
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

@end
