//
//  AdjustmentViewCell.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/28/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdjustmentView.h"

@interface AdjustmentViewCell : UITableViewCell

@property (nonatomic, retain) AdjustmentView *adjustmentView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)redisplay;

@end
