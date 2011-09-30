//
//  SettingsViewController.h
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;

@end

@protocol SettingsViewControllerDelegate

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;

@end
