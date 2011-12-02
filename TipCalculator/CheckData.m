//
//  CheckData.m
//  TipCalculator
//
//  Created by arn on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckData.h"

static CheckData *sharedCheckData;

@implementation CheckData

@synthesize currentCheck = currentCheck_;

- (id)init
{
    self = [super init];
    if (self) {
        currentCheck_ = [[Check alloc] init];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];  // this needs to be [super initWithCoder:aDecoder] if the superclass implements NSCoding
	if (self) {
		self.currentCheck = [decoder decodeObjectForKey:@"checkDataCurrentCheck"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// add [super encodeWithCoder:encoder] if the superclass implements NSCoding
	[encoder encodeObject:currentCheck_ forKey:@"checkDataCurrentCheck"];
}

- (void)dealloc
{
    [currentCheck_ release];
    [super dealloc];
}

#pragma mark - Singleton Methods

+ (CheckData *)sharedCheckData
{
	if (sharedCheckData == nil) {
		sharedCheckData = [[super allocWithZone:NULL] init];
	}
	return sharedCheckData;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedCheckData] retain];
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
