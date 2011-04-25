#import <Foundation/Foundation.h>
#import "BobPage.h"
#import "BobCenteringImageScrollView.h"
#import "BobDiskLoadOperation.h"
#import "BobCache.h"
#import "LoadingView.h"
#import "BobPhotoSource.h"
#import "BobPhoto.h"

@protocol BobPhotoPageTouchDelegate;

@interface BobPhotoPage : BobPage<BobCenteringImageScrollViewDelegate> {
    BobCenteringImageScrollView *_scrollView;
    BobDiskLoadOperation *_bobDiskLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    id<BobPhotoSource> photoSource_;
    LoadingView *loadingView;
    id<BobPhotoPageTouchDelegate> touchDelegate;
    BobCache *bobThumbnailCache;
}

@property (nonatomic, retain) BobDiskLoadOperation *bobDiskLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, assign) id<BobPhotoPageTouchDelegate> touchDelegate;
@property (nonatomic, retain) BobCache *bobThumbnailCache;

-(void) setPhoto:(BobPhoto *) photoSource;

@end

@protocol BobPhotoPageTouchDelegate <NSObject>
-(void) photoViewTouched:(BobPhotoPage *) bobPhotoPage;
@end