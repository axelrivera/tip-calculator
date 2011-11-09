//
//  TaxViewController.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/4/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaxViewControllerDelegate;

@interface TaxViewController : UITableViewController

@property (nonatomic, assign) id <TaxViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSDecimalNumber *taxRate;

@end

@protocol TaxViewControllerDelegate

- (void)taxViewControllerDidFinish:(TaxViewController *)controller;

@end
