//
//  Settings.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DefaultCurrencyAutomatic = -1,
    DefaultCurrencyDollar = 1,
    DefaultCurrencyPound = 2,
    DefaultCurrencyEuro = 3,
    DefaultCurrencyFranc = 4,
    DefaultCurrencyKrone = 5
} DefaultCurrency;

typedef enum {
    DefaultRoundingNone = -1,
    DefaultRoundingTotal = 1,
    DefaultRoundingTotalPerPerson = 2,
    DefaultRoundingTip = 3,
    DefaultRoundingTipPerPerson = 4
} DefaultRounding;

@interface Settings : NSObject

@property (nonatomic, assign) DefaultCurrency currency;
@property (nonatomic, assign) DefaultRounding rounding;
@property (nonatomic, assign) BOOL tipOnTax;
@property (nonatomic, assign) BOOL taxOnAdjustments;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL shakeToClear;
@property (nonatomic, retain) NSDecimalNumber *taxRate;

+ (Settings *)sharedSettings;

@end
