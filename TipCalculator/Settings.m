//
//  Settings.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Settings.h"
#import "NSDecimalNumber+Check.h"
#import "ControllerConstants.h"

#define kCurrencyTypeAutomatic @"CurrencyTypeAutomatic"
#define kCurrencyTypeDollar @"CurrencyTypeDollar"
#define kCurrencyTypePound @"CurrencyTypePound"
#define kCurrencyTypeEuro @"CurrencyTypeEuro"
#define kCurrencyTypeFranc @"CurrencyTypeFranc"
#define kCurrencyTypeKrone @"CurrencyTypeKrone"

#define kRoundingTypeNone @"RoundingTypeNone"
#define kRoundingTypeTotal @"RoundingTypeTotal"
#define kRoundingTypeTip @"RoundingTypeTip"

#define kTaxRateDecimalPlacesFactor -2

// The order of the arguments must match the order of the enum types
#define kCurrencyStringArgs @"Auto",@"Dollar ($)",@"Pound (£)",@"Euro (€)",@"Swiss Franc (CHF)",@"Krone/Krona (Kr)",nil
#define kRoundingStringsArgs @"No Rounding",@"Round Total",@"Round Tip",nil

#define kSettingsCurrencyKey @"RLTipCalculatorCurrencyKey"
#define kSettingsRoundingKey @"RLTipCalculatorRoundingKey"
#define kSettingsAdjustmentConfirmationKey @"RLTipCalculatorAdjustmentConfirmationKey"
#define kSettingsTipOnTaxKey @"RLTipCalculatorTipOnTaxKey"
#define kSettingsSoundKey @"RLTipCalculatorSoundKey"
#define kSettingsShakeToClearKey @"RLTipCalculatorShakeToClearKey"
#define kSettingsTaxRateKey @"RLTipCalculatorTaxRateKey"

static NSArray *currencyArray_;
static NSArray *roundingArray_;

CurrencyType const kDefaultCurrency = CurrencyTypeAutomatic;
RoundingType const kDefaultRounding = RoundingTypeNone;
BOOL const kDefaultAdjustmentConfirmation = YES;
BOOL const kDefaultTipOnTax = YES;
BOOL const kDefaultSound = YES;
BOOL const kDefaultShakeToClear = YES;
NSString * const kDefaultTaxRate = @"0.0";

static Settings *sharedSettings_;

@implementation Settings

@synthesize currency = currency_;
@synthesize rounding = rounding_;
@synthesize adjustmentConfirmation = adjustmentConfirmation_;
@synthesize tipOnTax = tipOnTax_;
@synthesize sound = sound_;
@synthesize shakeToClear = shakeToClear_;
@synthesize taxRate = taxRate_;

- (id)init
{
    self = [super init];
    if (self) {
        NSString *currencyStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsCurrencyKey];
		if (currencyStr == nil) {
			currencyStr = [Settings stringForCurrencyType:kDefaultCurrency];
		}
		self.currency = [Settings currencyTypeForKey:currencyStr];
        
        NSString *roundingStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsRoundingKey];
        if (roundingStr == nil) {
            roundingStr = [Settings stringForRoundingType:kDefaultRounding];
        }
        self.rounding = [Settings roundingTypeForKey:roundingStr];
        
		NSNumber *adjustmentConfirmation = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsAdjustmentConfirmationKey];
		if (adjustmentConfirmation == nil) {
			adjustmentConfirmation = [NSNumber numberWithBool:kDefaultAdjustmentConfirmation];
		}
		self.adjustmentConfirmation = [adjustmentConfirmation boolValue];
		
        NSNumber *tipOnTax = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsTipOnTaxKey];
        if (tipOnTax == nil) {
            tipOnTax = [NSNumber numberWithBool:kDefaultTipOnTax];
        }
        self.tipOnTax = [tipOnTax boolValue];
        
        NSNumber *sound = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsSoundKey];
        if (sound == nil) {
            sound = [NSNumber numberWithBool:kDefaultSound];
        }
        self.sound = [sound boolValue];
        
        NSNumber *shakeToClear = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsShakeToClearKey];
        if (shakeToClear == nil) {
            shakeToClear = [NSNumber numberWithBool:kDefaultShakeToClear];
        }
        self.shakeToClear = [shakeToClear boolValue];
        
        NSString *taxRateStr = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingsTaxRateKey];
        if (taxRateStr == nil) {
            taxRateStr = kDefaultTaxRate;
        }
        self.taxRate = [NSDecimalNumber decimalNumberWithString:taxRateStr];
    }
    return self;
}
 
- (void)dealloc
{
    [taxRate_ release];
    [super dealloc];
}

#pragma mark - Custom Setters

- (void)setCurrency:(CurrencyType)currency
{
   	currency_ = currency;
	[[NSUserDefaults standardUserDefaults] setObject:[Settings keyForCurrencyType:currency] forKey:kSettingsCurrencyKey];
	[[NSUserDefaults standardUserDefaults] synchronize]; 
}

- (void)setRounding:(RoundingType)rounding
{
    rounding_ = rounding;
    [[NSUserDefaults standardUserDefaults] setObject:[Settings keyForRoundingType:rounding] forKey:kSettingsRoundingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAdjustmentConfirmation:(BOOL)adjustmentConfirmation
{
	adjustmentConfirmation_ = adjustmentConfirmation;
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:adjustmentConfirmation]
																	   forKey:kSettingsAdjustmentConfirmationKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTipOnTax:(BOOL)tipOnTax
{
    tipOnTax_ = tipOnTax;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:tipOnTax] forKey:kSettingsTipOnTaxKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setSound:(BOOL)sound
{
    sound_ = sound;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sound] forKey:kSettingsSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setShakeToClear:(BOOL)shakeToClear
{
    shakeToClear_ = shakeToClear;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:shakeToClear] forKey:kSettingsShakeToClearKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTaxRate:(NSDecimalNumber *)taxRate
{
    [taxRate_ autorelease];
	taxRate_ = [taxRate retain];
	[[NSUserDefaults standardUserDefaults] setObject:[taxRate stringValue] forKey:kSettingsTaxRateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Custom Methods

- (NSString *)currencyString
{
    return [Settings stringForCurrencyType:currency_];
}

- (NSString *)roundingString
{
    return [Settings stringForRoundingType:rounding_];
}

- (NSString *)adjustmentConfirmationString
{
	NSString *string = nil;
	if (adjustmentConfirmation_) {
		string = @"Yes";
	} else {
		string = @"No";
	}
	return string;
}

- (NSString *)tipOnTaxString
{
    NSString *string = nil;
    if (tipOnTax_) {
        string = @"Yes";
    } else {
        string = @"No";
    }
    return string;
}

- (NSString *)taxString
{
    return [taxRate_ taxString]; 
}

- (NSDecimalNumber *)taxRatePercentage
{
    return [taxRate_ decimalNumberByMultiplyingByPowerOf10:kTaxRateDecimalPlacesFactor]; 
}

- (NSLocale *)currentLocale
{
    NSLocale *locale = nil;
    switch (currency_) {
        case CurrencyTypeAutomatic:
            locale = [NSLocale autoupdatingCurrentLocale];
            break;
        case CurrencyTypeDollar:
            locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
            break;
        case CurrencyTypePound:
            locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"] autorelease];
            break;
        case CurrencyTypeEuro:
            locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"es_ES_EUR"] autorelease];
            break;
        case CurrencyTypeFranc:
            locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ge_CH"] autorelease];
            break;
        case CurrencyTypeKrone:
            locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"da_DK_DKK"] autorelease];
            break;
        default:
            break;
    }
    return locale;
}

#pragma mark - Custom Class Methods

+ (NSString *)stringForCurrencyType:(CurrencyType)currencyType
{
    return [[Settings currencyTypeArray] objectAtIndex:currencyType];
}

+ (NSString *)stringForRoundingType:(RoundingType)roundingType
{
    return [[Settings roundingTypeArray] objectAtIndex:roundingType];
}

+ (NSArray *)currencyTypeArray
{
    if (currencyArray_ == nil) {
        currencyArray_ = [[NSArray alloc] initWithObjects:kCurrencyStringArgs];
    }
    return currencyArray_;
}

+ (NSArray *)roundingTypeArray
{
    if (roundingArray_ == nil) {
        roundingArray_ = [[NSArray alloc] initWithObjects:kRoundingStringsArgs];
    }
    return roundingArray_;
}

+ (CurrencyType)currencyTypeForKey:(NSString *)key
{
    CurrencyType type;
    if ([key isEqualToString:kCurrencyTypeAutomatic]) {
        type = CurrencyTypeAutomatic;
    } else if ([key isEqualToString:kCurrencyTypeDollar]) {
        type = CurrencyTypeDollar;
    } else if ([key isEqualToString:kCurrencyTypePound]) {
        type = CurrencyTypePound;
    } else if ([key isEqualToString:kCurrencyTypeEuro]) {
        type = CurrencyTypeEuro;
    } else if ([key isEqualToString:kCurrencyTypeFranc]) {
        type = CurrencyTypeFranc;
    } else if ([key isEqualToString:kCurrencyTypeKrone]) {
        type = CurrencyTypeKrone;
    } else {
        type = CurrencyTypeAutomatic;
    }
    return type;
}

+ (NSString *)keyForCurrencyType:(CurrencyType)currencyType
{
    NSString *key = nil;
    switch (currencyType) {
        case CurrencyTypeAutomatic:
            key = kCurrencyTypeAutomatic;
            break;
        case CurrencyTypeDollar:
            key = kCurrencyTypeDollar;
            break;
        case CurrencyTypePound:
            key = kCurrencyTypePound;
            break;
        case CurrencyTypeEuro:
            key = kCurrencyTypeEuro;
            break;
        case CurrencyTypeFranc:
            key = kCurrencyTypeFranc;
            break;
        case CurrencyTypeKrone:
            key = kCurrencyTypeKrone;
            break;
        default:
            key = kCurrencyTypeAutomatic;
            break;
    }
    return key;
}

+ (RoundingType)roundingTypeForKey:(NSString *)key
{
    RoundingType type;
    if ([key isEqualToString:kRoundingTypeNone]) {
        type = RoundingTypeNone;
    } else if ([key isEqualToString:kRoundingTypeTotal]) {
        type = RoundingTypeTotal;
    } else if ([key isEqualToString:kRoundingTypeTip]) {
        type = RoundingTypeTip;
    } else {
        type = RoundingTypeNone;
    }
    return type;
}

+ (NSString *)keyForRoundingType:(RoundingType)roundingType
{
    NSString *key = nil;
    switch (roundingType) {
        case RoundingTypeNone:
            key = kRoundingTypeNone;
            break;
        case RoundingTypeTotal:
            key = kRoundingTypeTotal;
            break;
        case RoundingTypeTip:
            key = kRoundingTypeTip;
            break;
        default:
            key = kRoundingTypeNone;
            break;
    }
    return key;
}

#pragma mark - Singleton Methods

+ (Settings *)sharedSettings
{
	if (sharedSettings_ == nil) {
		sharedSettings_ = [[super allocWithZone:NULL] init];
	}
	return sharedSettings_;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedSettings] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
	//do nothing
}

- (id)autorelease
{
	return self;
}

@end
