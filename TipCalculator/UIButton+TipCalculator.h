//
//  UIButton+TipCalculator.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/23/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TipCalculator)

+ (UIButton *)whiteButtonAtPoint:(CGPoint)point;
+ (UIButton *)orangeButtonAtPoint:(CGPoint)point;
+ (UIButton *)greenButtonAtPoint:(CGPoint)point;
+ (UIButton *)redButtonAtPoint:(CGPoint)point;

@end
