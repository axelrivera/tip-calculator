//
//  Settings.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CurrencyTypeAutomatic,
    CurrencyTypeDollar,
    CurrencyTypePound,
    CurrencyTypeEuro,
    CurrencyTypeFranc,
    CurrencyTypeKrone
} CurrencyType;

typedef enum {
    RoundingTypeNone,
    RoundingTypeTotalUp,
    RoundingTypeTipUp,
	RoundingTypeTotalDown,
	RoundingTypeTipDown
} RoundingType;

@interface Settings : NSObject

@property (nonatomic, assign) CurrencyType currency;
@property (nonatomic, assign) RoundingType rounding;
@property (nonatomic, assign) BOOL adjustmentConfirmation;
@property (nonatomic, assign) BOOL tipOnTax;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL shakeToClear;
@property (nonatomic, retain) NSDecimalNumber *taxRate;

+ (Settings *)sharedSettings;

+ (NSString *)stringForCurrencyType:(CurrencyType)currencyType;
+ (NSString *)stringForRoundingType:(RoundingType)roundingType;

+ (NSArray *)currencyTypeArray;
+ (NSArray *)roundingTypeArray;

+ (CurrencyType)currencyTypeForKey:(NSString *)key;
+ (NSString *)keyForCurrencyType:(CurrencyType)currencyType;
+ (RoundingType)roundingTypeForKey:(NSString *)key;
+ (NSString *)keyForRoundingType:(RoundingType)roundingType;

- (NSString *)currencyString;
- (NSString *)roundingString;
- (NSString *)adjustmentConfirmationString;
- (NSString *)tipOnTaxString;
- (NSString *)taxString;

- (NSDecimalNumber *)taxRatePercentage;

- (NSLocale *)currentLocale;

@end
