#import <Foundation/Foundation.h>
#import "BSGView.h"
#import "BobCache.h"


@interface BobPhotoViewController : UIViewController<BSGDatasource, BSGViewDelegate> {
    @private 
	NSMutableArray *_photos;
	NSMutableDictionary *_thumbnailImages;
	NSInteger numberOfEntriesPerRow;
	BSGView *_bsgView;
    NSOperationQueue *operationQueue;
	BobCache *bobCache;
    UIEdgeInsets _contentInsetsLandscape;
    UIEdgeInsets _contentInsetsPortrait;
}

@property (nonatomic, retain) NSMutableArray *photos;

@end
