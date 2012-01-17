//
//  FullVersionViewController.h
//  TipCalculator
//
//  Created by Axel Rivera on 1/17/12.
//  Copyright (c) 2012 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullVersionViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *downloadButton;

- (IBAction)dismissAction:(id)sender;
- (IBAction)downloadAction:(id)sender;

@end
