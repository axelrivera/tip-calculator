//
//  AdjustmentsViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustmentsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITableView *adjusmentsTable;
@property (nonatomic, assign) UIViewController *contentViewController;

@end