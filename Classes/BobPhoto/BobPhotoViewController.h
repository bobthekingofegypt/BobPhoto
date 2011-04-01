#import <Foundation/Foundation.h>
#import "BSGView.h"
#import "BobCache.h"


@interface BobPhotoViewController : UIViewController<BSGDatasource, BSGViewDelegate> {
    
	NSMutableArray *_photos;
    
    @private 
	NSMutableDictionary *_thumbnailImages;
	NSInteger numberOfEntriesPerRow;
	BSGView *_bsgView;
    NSOperationQueue *operationQueue;
	BobCache *bobCache;
}

@property (nonatomic, retain) NSMutableArray *photos;

@end
