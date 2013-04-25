//
//  MMatrix.m
//  NSExport
//
//  Created by Peter Molfese on 9/25/08.
//  Copyright 2008 Fireball Presentations. All rights reserved.
//

#import "MMatrix.h"


@implementation MMatrix

@synthesize theData;
@synthesize cols;
@synthesize rows;

-(id)init
{
	self = [super init];
	if( self == nil )
		return nil;
	
	self.cols = 129;
	self.rows = 250;
	theData = [[NSMutableArray alloc] initWithCapacity:((self.cols)*(self.rows))];
	return self;
}

-(void)addDataPoint:(NSNumber *)aDataPoint
{
	[theData addObject:aDataPoint];
}

-(NSNumber *)getDataPointAtIndex:(NSUInteger)theIndex
{
	return [[self theData] objectAtIndex:theIndex];
}

-(NSNumber *)getDataPointOnChannel:(NSUInteger)aCol onRow:(NSUInteger)aRow
{
	return [[self theData] objectAtIndex:(aCol * aRow)];
}

-(NSString *)getAllPoints
{
	NSMutableString *allD = [NSMutableString stringWithCapacity:(self.cols*self.rows)];
	int i, j=0;
	for( i=0; i<[[self theData] count]; i++ )
	{
		if( j == self.cols )
		{
			[allD appendString:@"\r"];
			j=0;
			[allD appendString:[[[self theData] objectAtIndex:i] stringValue]];
			[allD appendString:@"\t"];
			j++;
		}
		else if( j == (self.cols - 1) )		//added to address a bug in MCAT 2.X
		{
			[allD appendString:[[[self theData] objectAtIndex:i] stringValue]];
			j++;
		}
		else
		{
			[allD appendString:[[[self theData] objectAtIndex:i] stringValue]];
			[allD appendString:@"\t"];
			j++;
		}
		
	}
	[allD appendString:@"\r"];
	return allD;
}

@end
