#import "BobDiskPhoto.h"


@implementation BobDiskPhoto

@synthesize thumbnailLocation, imageLocation, title, description;

-(void) dealloc {
	[thumbnailLocation release];
	[imageLocation release];
	[title release];
	[description release];
	
	[super dealloc];
}

@end
