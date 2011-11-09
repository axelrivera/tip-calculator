//
//  TableSelectViewController.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/3/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableSelectViewControllerDelegate;

@interface TableSelectViewController : UITableViewController

@property (nonatomic, assign) id <TableSelectViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger selectID;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, copy) NSString *tableHeaderTitle;
@property (nonatomic, copy) NSString *tableFooterTitle;

@end

@protocol TableSelectViewControllerDelegate

- (void)tableSelectViewControllerDidFinish:(TableSelectViewController *)controller;

@end
