//
//  MMatrix.h
//  NSExport
//
//  Created by Peter Molfese on 9/25/08.
//  Copyright 2008 Fireball Presentations. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MMatrix : NSObject 
{
	NSMutableArray *theData;
	NSUInteger cols;
	NSUInteger rows;
}
@property(readwrite,copy) NSArray *theData;
@property(readwrite) NSUInteger cols;
@property(readwrite) NSUInteger rows;
-(void)addDataPoint:(NSNumber *)aDataPoint;
-(NSNumber *)getDataPointAtIndex:(NSUInteger)theIndex;
-(NSNumber *)getDataPointOnChannel:(NSUInteger)aCol onRow:(NSUInteger)aRow;
-(NSString *)getAllPoints;

@end
