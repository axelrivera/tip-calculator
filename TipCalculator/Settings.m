//
//  Settings.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Settings.h"

// The order of the arguments must match the order of the enum types
#define kCurrencyStringArgs @"Auto",@"Dollar ($)",@"Pound (£)",@"Euro (€)",@"Franc (Fr)",@"Krone/Krona (Kr)",nil
#define kRoundingStringsArgs @"No Rounding",@"Round Total",@"Round Total / Person",@"Round Tip",@"Round Tip / Person",nil

#define kDefaultCurrencyKey @"RLTipCalculatorDefaultCurrencyKey"
#define kDefaultRoundingKey @"RLTipCalculatorDefaultRoundingKey"
#define kDefaultTipOnTaxKey @"RLTipCalculatorDefaultTipOnTaxKey"
#define kDefaultTaxOnAdjustmentsKey @"RLTipCalculatorDefaultTaxOnAdjustmentsKey"
#define kDefaultSoundKey @"RLTipCalculatorDefaultSoundKey"
#define kDefaultShakeToClearKey @"RLTipCalculatorDefaultShakeToClearKey"
#define kDefaultTaxRateKey @"RLTipCalculatorDefaultTaxRateKey"

static NSArray *currencyArray_;
static NSArray *roundingArray_;

CurrencyType const kDefaultCurrency = CurrencyTypeAutomatic;
RoundingType const kDefaultRounding = RoundingTypeNone;
BOOL const kDefaultTipOnTax = NO;
BOOL const kDefaultTaxOnAdjustments = NO;
BOOL const kDefaultSound = YES;
BOOL const kDefaultShakeToClear = YES;
NSString * const kDefaultTaxRate = @"0.0";

static Settings *sharedSettings_;

@implementation Settings

@synthesize currency = currency_;
@synthesize rounding = rounding_;
@synthesize tipOnTax = tipOnTax_;
@synthesize taxOnAdjustments = taxOnAdjustments_;
@synthesize sound = sound_;
@synthesize shakeToClear = shakeToClear_;
@synthesize taxRate = taxRate_;

- (id)init
{
    self = [super init];
    if (self) {
        NSNumber *currency = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultCurrencyKey];
		if (currency == nil) {
			currency = [NSNumber numberWithInteger:kDefaultCurrency];
		}
		self.currency = (CurrencyType)[currency integerValue];
        
        NSNumber *rounding = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultRoundingKey];
        if (rounding == nil) {
            rounding = [NSNumber numberWithInteger:kDefaultRounding];
        }
        self.rounding = (RoundingType)[rounding integerValue];
        
        NSNumber *tipOnTax = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTipOnTaxKey];
        if (tipOnTax == nil) {
            tipOnTax = [NSNumber numberWithBool:kDefaultTipOnTax];
        }
        self.tipOnTax = [tipOnTax boolValue];
        
        NSNumber *taxOnAdjustments = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTaxOnAdjustmentsKey];
        if (taxOnAdjustments == nil) {
            taxOnAdjustments = [NSNumber numberWithBool:kDefaultTaxOnAdjustments];
        }
        self.taxOnAdjustments = [taxOnAdjustments boolValue];
        
        NSNumber *sound = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultSoundKey];
        if (sound == nil) {
            sound = [NSNumber numberWithBool:kDefaultSound];
        }
        self.sound = [sound boolValue];
        
        NSNumber *shakeToClear = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultShakeToClearKey];
        if (shakeToClear == nil) {
            shakeToClear = [NSNumber numberWithBool:kDefaultShakeToClear];
        }
        self.shakeToClear = [shakeToClear boolValue];
        
        NSString *taxRateStr = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultTaxRateKey];
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
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:currency] forKey:kDefaultCurrencyKey];
	[[NSUserDefaults standardUserDefaults] synchronize]; 
}

- (void)setRounding:(RoundingType)rounding
{
    rounding_ = rounding;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:rounding] forKey:kDefaultRoundingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTipOnTax:(BOOL)tipOnTax
{
    tipOnTax_ = tipOnTax;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:tipOnTax] forKey:kDefaultTipOnTaxKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setTaxOnAdjustments:(BOOL)taxOnAdjustments
{
    taxOnAdjustments_ = taxOnAdjustments;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:taxOnAdjustments] forKey:kDefaultTaxOnAdjustmentsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setSound:(BOOL)sound
{
    sound_ = sound;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sound] forKey:kDefaultSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setShakeToClear:(BOOL)shakeToClear
{
    shakeToClear_ = shakeToClear;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:shakeToClear] forKey:kDefaultShakeToClearKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTaxRate:(NSDecimalNumber *)taxRate
{
    [taxRate_ autorelease];
	taxRate_ = [taxRate retain];
	[[NSUserDefaults standardUserDefaults] setObject:[taxRate stringValue] forKey:kDefaultTaxRateKey];
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

- (NSString *)taxString
{
    return [taxRate_ stringValue]; 
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
