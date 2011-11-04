//
//  SettingsViewController.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "TableSelectViewController.h"
#import "TaxViewController.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController <TableSelectViewControllerDelegate, TaxViewControllerDelegate>
{
    Settings *settings_;
}

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;

@end

@protocol SettingsViewControllerDelegate

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;

@end
