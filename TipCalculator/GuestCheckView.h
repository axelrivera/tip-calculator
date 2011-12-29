//
//  GuestCheckView.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/23/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestCheckView : UIView
{
	UIImageView *imageView_;
    UILabel *totalTipTitleLabel_;
    UILabel *totalToPayTitleLabel_;
    UILabel *totalPerPersonTitleLabel_;
}

@property (nonatomic, retain, readonly) UILabel *totalTipLabel;
@property (nonatomic, retain, readonly) UILabel *totalToPayLabel;
@property (nonatomic, retain, readonly) UILabel *totalPerPersonLabel;

@end
