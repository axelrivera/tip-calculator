//
//  AdjustmentValueView.m
//  TipCalculator
//
//  Created by arn on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AdjustmentValueView.h"

@implementation AdjustmentValueView

@synthesize view = view_;
@synthesize title = title_;
@synthesize leftButton = leftButton_;
@synthesize rightButton = rightButton_;
@synthesize slider = slider_;

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed: @"AdjustmentValueView" owner: self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    return self;
}


- (void)dealloc
{
    [title_ release];
    [leftButton_ release];
    [rightButton_ release];
    [slider_ release];
    [view_ release];
    [super dealloc];
}

@end
