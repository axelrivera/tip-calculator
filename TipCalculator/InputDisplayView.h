//
//  NumberPadInputView.h
//  TipCalculator
//
//  Created by Axel Rivera on 10/27/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputDisplayView : UIButton

@property (nonatomic, retain, readonly) UILabel *textLabel;
@property (nonatomic, retain, readonly) UILabel *detailTextLabel;
@property (nonatomic, retain) UIImageView *accessoryView;

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *textColorSelected;
@property (nonatomic, retain) UIImage *imageAccessory;
@property (nonatomic, retain) UIImage *imageAccessorySelected;

@property (readwrite, retain) UIView *inputView;
@property (readwrite, retain) UIView *inputAccessoryView;

@end
