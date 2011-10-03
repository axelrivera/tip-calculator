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

- (id)init
{
    self = [[RLInputButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
    if (self) {
        [self setImage:[UIImage imageNamed:@"button.png"]
              forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"button_pressed.png"]
              forState:UIControlStateHighlighted];
    }
    return self;
}

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

@end