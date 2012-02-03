#import <UIKit/UIKit.h>
#import "BSGView.h"
#import "BobCache.h"


@interface BobPhotoViewController : UIViewController<BSGDatasource, BSGViewDelegate> {
	NSMutableDictionary *thumbnailImages_;
	BSGView *bsgView_;
    NSOperationQueue *operationQueue;
	BobCache *bobCache;
    
    @private
    NSMutableArray *photos_;
    NSInteger maximumConcurrentlyLoadingThumbnails_;
    NSInteger maximumConcurrentlyLoadingImages_;
}

@property (nonatomic, assign) NSInteger maximumConcurrentlyLoadingThumbnails;
@property (nonatomic, assign) NSInteger maximumConcurrentlyLoadingImages;
@property (nonatomic, retain) NSMutableArray *photos;

-(id) initWithPhotos:(NSMutableArray *)photos;

@end
