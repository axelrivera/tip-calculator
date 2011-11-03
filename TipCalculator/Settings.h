//
//  Settings.h
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNumberOfCurrencyItems 6
typedef enum {
    CurrencyTypeAutomatic = 0,
    CurrencyTypeDollar = 1,
    CurrencyTypePound = 2,
    CurrencyTypeEuro = 3,
    CurrencyTypeFranc = 4,
    CurrencyTypeKrone = 5
} CurrencyType;

#define kNumberOfRoundingItems 5
typedef enum {
    RoundingTypeNone = 0,
    RoundingTypeTotal = 1,
    RoundingTypeTotalPerPerson = 2,
    RoundingTypeTip = 3,
    RoundingTypeTipPerPerson = 4
} RoundingType;

@interface Settings : NSObject

@property (nonatomic, assign) CurrencyType currency;
@property (nonatomic, assign) RoundingType rounding;
@property (nonatomic, assign) BOOL tipOnTax;
@property (nonatomic, assign) BOOL taxOnAdjustments;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL shakeToClear;
@property (nonatomic, retain) NSDecimalNumber *taxRate;

+ (Settings *)sharedSettings;

+ (NSString *)stringForCurrencyType:(CurrencyType)currencyType;
+ (NSString *)stringForRoundingType:(RoundingType)roundingType;

+ (NSArray *)currencyTypeArray;
+ (NSArray *)roundingTypeArray;

- (NSString *)currencyString;
- (NSString *)roundingString;
- (NSString *)taxString;

@end
