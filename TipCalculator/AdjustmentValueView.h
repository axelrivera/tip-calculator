//
//  AdjustmentValueView.h
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustmentValueView : UIView

@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UIButton *leftButton;
@property (nonatomic, retain, readonly) UIButton *rightButton;
@property (nonatomic, retain, readonly) UISlider *slider;

+ (AdjustmentValueView *)adjustmentViewForCellWithTag:(NSInteger)tag;

@end
