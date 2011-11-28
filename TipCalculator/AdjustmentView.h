//
//  AdjustmentView.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/28/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustmentView : UIView

@property (nonatomic, retain, readonly) UILabel *textLabel1;
@property (nonatomic, retain, readonly) UILabel *textLabel2;
@property (nonatomic, retain, readonly) UILabel *detailTextLabel1;
@property (nonatomic, retain, readonly) UILabel *detailTextLabel2;

- (void)setRowTextColor;
- (void)setSummaryTextColor;

@end
