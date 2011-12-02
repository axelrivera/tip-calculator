//
//  FileHelpers.m
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
	// Get list of document directories in sandbox
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get one and only document directory from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	
	// Append passed in file name to that directory, return it
	return [documentDirectory stringByAppendingPathComponent:fileName];
}

NSString *pathInMainBundle(NSString *fileName)
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

NSURL *applicationDocumentsDirectory(void)
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}