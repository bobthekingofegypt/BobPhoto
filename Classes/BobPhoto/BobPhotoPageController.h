#import <UIKit/UIKit.h>
#import "BobPageScrollView.h"
#import "BobCache.h"
#import "BobPhotoPage.h"

@interface BobPhotoPageController : UIViewController<BobPageScrollViewDatasource, BobPhotoPageTouchDelegate> {
	NSMutableArray *_photos;
	BobPageScrollView *_bobPageScrollView;
	NSUInteger currentIndex;
    NSOperationQueue *operationQueue;
    BobCache *bobCache;
    
    @private 
    BOOL showingChrome;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index;
-(void) setCurrentIndex:(NSUInteger)index;

@end
