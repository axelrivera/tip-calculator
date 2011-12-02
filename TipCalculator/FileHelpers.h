//
//  FileHelpers.h
//
//  Copyright 2010 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *pathInDocumentDirectory(NSString *fileName);
NSString *pathInMainBundle(NSString *fileName);
NSURL *applicationDocumentsDirectory(void);
