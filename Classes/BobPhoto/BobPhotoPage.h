#import <UIKit/UIKit.h>
#import "BobPage.h"
#import "BobCenteringImageScrollView.h"
#import "BobImageLoadOperation.h"
#import "BobCache.h"
#import "LoadingView.h"
#import "BobPhotoSource.h"
#import "BobPhoto.h"

@protocol BobPhotoPageTouchDelegate;

@interface BobPhotoPage : BobPage<BobCenteringImageScrollViewDelegate> {
    BobCenteringImageScrollView *_scrollView;
    BobImageLoadOperation *_bobImageLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    id<BobPhotoSource> photoSource_;
    LoadingView *loadingView;
    id<BobPhotoPageTouchDelegate> touchDelegate;
    BobCache *bobThumbnailCache;
}

@property (nonatomic, retain) BobImageLoadOperation *bobImageLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, assign) id<BobPhotoPageTouchDelegate> touchDelegate;
@property (nonatomic, retain) BobCache *bobThumbnailCache;

-(void) setPhoto:(BobPhoto *) photoSource;

@end

@protocol BobPhotoPageTouchDelegate <NSObject>
-(void) photoViewTouched:(BobPhotoPage *) bobPhotoPage;
@end