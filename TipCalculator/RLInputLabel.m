//
//  RLInputLabel.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/4/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "RLInputLabel.h"

@implementation RLInputLabel

@synthesize inputView, inputAccessoryView;

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.highlighted = YES;
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    self.highlighted = NO;
    return YES;
}

@end
