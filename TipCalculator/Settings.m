//
//  Settings.m
//  TipCalculator
//
//  Created by Axel Rivera on 11/2/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import "Settings.h"

#define kDefaultCurrencyKey @"DefaultCurrencyKey"
#define kDefaultRoundingKey @"DefaultRoundingKey"
#define kDefaultTipOnTaxKey @"DefaultTipOnTaxKey"
#define kDefaultTaxOnAdjustmentsKey @"DefaultTaxOnAdjustmentsKey"
#define kDefaultSoundKey @"DefaultSoundKey"
#define kDefaultShakeToClearKey @"DefaultShakeToClearKey"
#define kDefaultTaxRateKey @"DefaultTaxRateKey"

#define kDefaultCurrency DefaultCurrencyAutomatic
#define kDefaultRounding DefaultRoundingNone
#define kDefaultTipOnTax NO
#define kDefaultTaxOnAdjustments NO
#define kDefaultSound YES
#define kDefaultShakeToClear YES
#define kDefaultTaxRate @"0.0"

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
        NSInteger currency = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultCurrencyKey];
		if (currency == 0) {
			currency = (NSInteger)kDefaultCurrencyKey;
		}
		self.currency = (DefaultCurrency)currency;
        
        NSInteger rounding = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultRoundingKey];
        if (rounding == 0) {
            rounding = (NSInteger)rounding;
        }
        self.rounding = (DefaultRounding)rounding;
        
        BOOL tipOnTax = [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultTipOnTaxKey];
        self.tipOnTax = tipOnTax;
        
        BOOL taxOnAdjustments = [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultTaxOnAdjustmentsKey];
        self.taxOnAdjustments = taxOnAdjustments;
        
        BOOL sound = [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultSoundKey];
        self.sound = sound;
        
        BOOL shakeToClear = [[NSUserDefaults standardUserDefaults] boolForKey:kDefaultShakeToClearKey];
        self.shakeToClear = shakeToClear;
        
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

- (void)setCurrency:(DefaultCurrency)currency
{
   	currency_ = currency;
	[[NSUserDefaults standardUserDefaults] setInteger:currency forKey:kDefaultCurrencyKey];
	[[NSUserDefaults standardUserDefaults] synchronize]; 
}

- (void)setRounding:(DefaultRounding)rounding
{
    rounding_ = rounding;
    [[NSUserDefaults standardUserDefaults] setInteger:rounding forKey:kDefaultRoundingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTipOnTax:(BOOL)tipOnTax
{
    tipOnTax_ = tipOnTax;
    [[NSUserDefaults standardUserDefaults] setInteger:tipOnTax forKey:kDefaultTipOnTaxKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setTaxOnAdjustments:(BOOL)taxOnAdjustments
{
    taxOnAdjustments_ = taxOnAdjustments;
    [[NSUserDefaults standardUserDefaults] setInteger:taxOnAdjustments forKey:kDefaultTaxOnAdjustmentsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setSound:(BOOL)sound
{
    sound_ = sound;
    [[NSUserDefaults standardUserDefaults] setInteger:sound forKey:kDefaultSoundKey];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)setShakeToClear:(BOOL)shakeToClear
{
    shakeToClear_ = shakeToClear;
    [[NSUserDefaults standardUserDefaults] setInteger:shakeToClear forKey:kDefaultShakeToClearKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTaxRate:(NSDecimalNumber *)taxRate
{
    [taxRate_ autorelease];
	taxRate_ = [taxRate retain];
	[[NSUserDefaults standardUserDefaults] setObject:[taxRate stringValue] forKey:kDefaultTaxRateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
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
