//
//  SummaryViewController.h
//  TipCalculator
//
//  Created by arn on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface SummaryViewController : UIViewController <SettingsViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *summaryTable;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)infoButtonAction:(id)sender;

@end
