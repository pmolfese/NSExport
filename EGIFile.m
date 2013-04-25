//
//  EGIFile.m
//  NSExport
//
//  Created by Peter Molfese on 9/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EGIFile.h"


@implementation EGIFile

@synthesize filePath;
@synthesize outputPath;
@synthesize numChannels;
@synthesize categories;

-(id)init
{
	self = [super init];
	if( self == nil )
		return nil;
	self.filePath = nil;
	self.outputPath = nil;
	self.numChannels = 129;
	self.categories = [NSMutableDictionary dictionaryWithCapacity:5];
	return self;
}

-(void)readFile
{
	NSAutoreleasePool *loadPool = [[NSAutoreleasePool alloc] init];
	NSData *myFile = [NSData dataWithContentsOfFile:self.filePath];
	int i, j, k, file_location;
	
	long version = EndianS32_BtoN(*((const long *)[myFile bytes]));
	if( version != 5 )
	{
		NSLog(@"Wrong Simple Binary Version");
		return;
	}
	
	//short year = EndianS16_BtoN(*((const short *)[myFile bytes] +2));
	//NSLog(@"Year: %i", year);
	//short month = EndianS16_BtoN(*((const short *)[myFile bytes] + 3));
//	NSLog(@"month: %i", month);
//	short day = EndianS16_BtoN(*((const short *)[myFile bytes] + 4));
//	NSLog(@"day: %i", day);
//	short hour = EndianS16_BtoN(*((const short *)[myFile bytes] + 5));
//	NSLog(@"hour: %i", hour);
//	short minute = EndianS16_BtoN(*((const short *)[myFile bytes] + 6));
//	NSLog(@"minute: %i", minute);
//	short second = EndianS16_BtoN(*((const short *)[myFile bytes] + 7));
//	NSLog(@"second: %i", second);
//	short sample_rate = EndianS16_BtoN(*((const short *)[myFile bytes] + 10));
//	NSLog(@"sample_rate: %i", sample_rate);
	short num_channels = EndianS16_BtoN(*((const short *)[myFile bytes] + 11));
	//NSLog(@"num_channels: %i", num_channels);
	self.numChannels = num_channels;
	//short board_gain = EndianS16_BtoN(*((const short *)[myFile bytes] + 12));
	//short conversion_bits = EndianS16_BtoN(*((const short *)[myFile bytes] + 13));
	//short amp_range = EndianS16_BtoN(*((const short *)[myFile bytes] + 14));
	short numCategories = EndianS16_BtoN(*((const short *)[myFile bytes] + 15)); 

	file_location = 32;
	NSMutableArray *categoriesArr = [NSMutableArray arrayWithCapacity:numCategories];
	for( i=0; i<numCategories; ++i )
	{
		char cat_length = *((const char *)[myFile bytes] + file_location);	//size of text field
		++file_location;
		NSString *myCatName = [NSString stringWithCString:([myFile bytes] + file_location) length:cat_length];
		file_location += cat_length;
		//NSLog(@"Category Name: %@", myCatName );
		[categoriesArr addObject:myCatName];
	}

	short num_segments = EndianS16_BtoN(*((const short *)([myFile bytes] + file_location)));
	file_location += 2;
	//NSLog(@"Num Segs: %i", num_segments);
	long samples_per_segment = EndianS32_BtoN(*((const long *)([myFile bytes] + file_location)));
	//NSLog(@"Num Samples per seg: %i", samples_per_segment);
	file_location += 4;
	short num_event_codes = EndianS16_BtoN(*((const short *)([myFile bytes] + file_location)));
	//NSLog(@"Num Events: %i", num_event_codes);
	file_location += 2;
	
	//read event codes
	
	//NSMutableArray *eventCodes = [NSMutableArray arrayWithCapacity:num_event_codes];
	for( i=0; i<num_event_codes; ++i )
	{
		NSString *my_event = [NSString stringWithCString:([myFile bytes] + file_location) length:4];
		NSLog(@"Event Found: %@", my_event);
		file_location += 4;
	}
	
	for( i=0; i<num_segments; ++i )
	{
		//Must Read Header of Segment -- and throw it out:
		file_location += 2;
		//Must Read Time Stamp and throw it out:
		file_location += 4;
		MMatrix *aMatrix = [[MMatrix alloc] init]; 
		[aMatrix setRows:(samples_per_segment/num_channels)];
		[aMatrix setCols:num_channels];
		for( j=0; j<samples_per_segment; ++j )
		{
			for( k=0; k<num_channels; k++ )
			{
				float tempSSR = *((const float *)([myFile bytes] + file_location));
				float SSR = NSSwapBigFloatToHost(NSConvertHostFloatToSwapped(tempSSR));
				[aMatrix addDataPoint:[NSNumber numberWithFloat:SSR]];
				file_location += 4;
			}
			//deal with event codes now
			for( k=0; k<num_event_codes; k++ )
			{
				file_location += 4;	//since we don't really use them, ignore them
			}
		}
		[categories setObject:aMatrix forKey:[categoriesArr objectAtIndex:i]];
	}
	[loadPool drain];
}

-(void)writeTextFile
{
	NSString *rootOfOutput = [NSString stringWithString:self.outputPath];
	rootOfOutput = [rootOfOutput stringByDeletingPathExtension];
	rootOfOutput = [rootOfOutput stringByAppendingString:@"_"];
	
	NSArray *allCats = [[self categories] allKeys];
	int i;
	for( i=0; i<[[self categories] count]; i++ )
	{
		NSMutableString *fullPath = [NSMutableString stringWithString:rootOfOutput];
		[fullPath appendString:[allCats objectAtIndex:i]];
		[fullPath appendString:@".txt"];
		MMatrix *aMatrix = [[self categories] objectForKey:[allCats objectAtIndex:i]];
		NSString *outData = [aMatrix getAllPoints];
		[outData writeToFile:fullPath atomically:YES encoding:1 error:NULL];
	}
}

@end
