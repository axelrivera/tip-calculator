//
//  TaxOptionsViewController.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/9/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@protocol TaxOptionsViewControllerDelegate;

@interface TaxOptionsViewController : UITableViewController

@property (nonatomic, assign) id <TaxOptionsViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger tipOnTaxIndex;
@property (nonatomic, assign) NSInteger taxOnAdjustmentsIndex;

@end

@protocol TaxOptionsViewControllerDelegate

- (void)taxOptionsViewControllerDidFinish:(TaxOptionsViewController *)controller;

@end
