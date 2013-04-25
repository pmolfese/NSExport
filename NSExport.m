#import <Foundation/Foundation.h>
#import "MMatrix.h"
#import "EGIFile.h"

int main (int argc, const char * argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if( argc < 2 )
	{
		NSLog(@"Correct Usage:\nNSExport file1.RAW file2.RAW\n");
		return 0;
	}
	
	
	NSLog(@"Net Station Export RAW-->TXT");
	int i;
	for( i=1; i<argc; i++ )
	{
		EGIFile *myFile = [[EGIFile alloc] init];
		[myFile setFilePath:[NSString stringWithCString:argv[i]]];
		[myFile setOutputPath:[NSString stringWithCString:argv[i]]];
		[myFile readFile];
		[myFile writeTextFile];
	}
	
    [pool drain];
    return 0;
}
