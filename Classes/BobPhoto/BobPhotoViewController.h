#import <Foundation/Foundation.h>
#import "BSGView.h"
#import "BobCache.h"


@interface BobPhotoViewController : UIViewController<BSGDatasource, BSGViewDelegate> {
    
	NSMutableArray *_photos;
    NSInteger maximumConcurrentlyLoadingThumbnails_;
    NSInteger maximumConcurrentlyLoadingImages_;
    
    @private 
	NSMutableDictionary *_thumbnailImages;
	NSInteger numberOfEntriesPerRow;
	BSGView *_bsgView;
    NSOperationQueue *operationQueue;
	BobCache *bobCache;
}

@property (nonatomic, assign) NSInteger maximumConcurrentlyLoadingThumbnails;
@property (nonatomic, assign) NSInteger maximumConcurrentlyLoadingImages;
@property (nonatomic, retain) NSMutableArray *photos;

@end
