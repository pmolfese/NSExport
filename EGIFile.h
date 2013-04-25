//
//  EGIFile.h
//  NSExport
//
//  Created by Peter Molfese on 9/25/08.
//  Copyright 2008 Fireball Presentations. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMatrix.h"


@interface EGIFile : NSObject 
{
	NSString *filePath;
	NSString *outputPath;
	NSUInteger numChannels;
	NSMutableDictionary *categories;
}
@property(readwrite, copy)NSString *filePath;
@property(readwrite, copy)NSString *outputPath;
@property(readwrite)NSUInteger numChannels;
@property(readwrite, assign)NSMutableDictionary *categories;
-(void)readFile;
-(void)writeTextFile;

@end
