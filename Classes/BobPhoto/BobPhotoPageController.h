#import <UIKit/UIKit.h>
#import "BobPageScrollView.h"
#import "BobCache.h"

@interface BobPhotoPageController : UIViewController<BobPageScrollViewDatasource> {
	NSMutableArray *_photos;
    NSMutableDictionary *_photoOperations;
	BobPageScrollView *_bobPageScrollView;
	NSUInteger currentIndex;
    NSOperationQueue *operationQueue;
    BobCache *bobCache;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index;
-(void) setCurrentIndex:(NSUInteger)index;

@end
