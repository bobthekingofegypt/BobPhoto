#import <Foundation/Foundation.h>
#import "TapDetectingImageView.h"


@protocol BobCenteringImageScrollViewDelegate;

@interface BobCenteringImageScrollView : UIScrollView<UIScrollViewDelegate, TapDetectingImageViewDelegate> {
	TapDetectingImageView *_imageView;
	BOOL _manualZooming;
    CGRect old;
    CGSize oldSize;
    id<BobCenteringImageScrollViewDelegate> touchDelegate;
    BOOL thumbnail;
    
    CGPoint tapLocation;
    BOOL multipleTouches;
}

@property (nonatomic, assign) id<BobCenteringImageScrollViewDelegate> touchDelegate;
@property (nonatomic,assign, getter=isManualZooming) BOOL manualZooming;

-(void) setScaledThumbnail:(UIImage *) image;
-(void) setImage:(UIImage *)image;
-(void) updateFrame:(CGRect)theFrame;

@end

@protocol BobCenteringImageScrollViewDelegate <NSObject>
-(void) bobCenteringImageScrollViewSingleClicked:(BobCenteringImageScrollView *)bobCenteringImageScrollView;
@end