#import <Foundation/Foundation.h>
#import "BobPage.h"
#import "BobCenteringImageScrollView.h"
#import "BobDiskLoadOperation.h"
#import "BobCache.h"
#import "LoadingView.h"

@protocol BobPhotoPageTouchDelegate;

@interface BobPhotoPage : BobPage<BobCenteringImageScrollViewDelegate> {
    BobCenteringImageScrollView *_scrollView;
    BobDiskLoadOperation *_bobDiskLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    NSString *path_;
    LoadingView *loadingView;
    id<BobPhotoPageTouchDelegate> touchDelegate;
}

@property (nonatomic, retain) BobDiskLoadOperation *bobDiskLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, assign) id<BobPhotoPageTouchDelegate> touchDelegate;

-(void) setPath:(NSString *) location;

@end

@protocol BobPhotoPageTouchDelegate <NSObject>
-(void) photoViewTouched:(BobPhotoPage *) bobPhotoPage;
@end