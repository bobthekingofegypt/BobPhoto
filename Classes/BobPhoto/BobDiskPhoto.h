#import <Foundation/Foundation.h>


@interface BobDiskPhoto : NSObject {

	NSString *thumbnailLocation;
	NSString *imageLocation;
	NSString *title;
	NSString *description;
	
}

@property (nonatomic, retain) NSString *thumbnailLocation;
@property (nonatomic, retain) NSString *imageLocation;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;

@end
