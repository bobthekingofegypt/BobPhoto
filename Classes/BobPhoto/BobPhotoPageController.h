#import <UIKit/UIKit.h>
#import "BobPagedScrollView.h"
#import "BobCache.h"
#import "BobPhotoPage.h"

@interface BobPhotoPageController : UIViewController<BobPagedScrollViewDatasource, BobPagedScrollViewDelegate, BobPhotoPageTouchDelegate> {
	NSMutableArray *photos_;
	BobPagedScrollView *bobPageScrollView_;
	NSUInteger currentIndex;
    NSOperationQueue *operationQueue;
    BobCache *bobCache;
    BobCache *bobThumbnailCache;
    BOOL showingChrome;
    NSTimer *slideshowTimer;
    BOOL playingSlideshow;
    UIBarButtonItem *play;
    UIBarButtonItem *left;
    UIBarButtonItem *right;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) BobCache *bobThumbnailCache;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index;
-(void) setCurrentIndex:(NSUInteger)index;
-(void) playSlideShow;

@end
