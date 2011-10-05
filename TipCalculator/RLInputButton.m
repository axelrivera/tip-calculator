//
//  RLButton.m
//  TipCalculator
//
//  Created by arn on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLInputButton.h"

@implementation RLInputButton

@synthesize inputView, inputAccessoryView;

- (void)dealloc
{
    [inputView release];
    [inputAccessoryView release];
    [super dealloc];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.selected = YES;
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    self.selected = NO;
    return YES;
}

@end
