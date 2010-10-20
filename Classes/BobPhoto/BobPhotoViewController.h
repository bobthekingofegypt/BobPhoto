#import <Foundation/Foundation.h>
#import "BSGView.h"
#import "BobCache.h"


@interface BobPhotoViewController : UIViewController<BSGDatasource, BSGViewDelegate> {

	NSMutableArray *_photos;
	NSMutableDictionary *_thumbnailImages;
	NSInteger numberOfEntriesPerRow;
	BSGView *_bsgView;
    NSOperationQueue *operationQueue;
	BobCache *bobCache;
    BOOL check;
}

@property (nonatomic, retain) NSMutableArray *photos;

@end
