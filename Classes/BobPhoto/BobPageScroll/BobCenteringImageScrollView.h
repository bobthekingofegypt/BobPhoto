#import <Foundation/Foundation.h>
#import "TapDetectingImageView.h"

@interface BobCenteringImageScrollView : UIScrollView<UIScrollViewDelegate, TapDetectingImageViewDelegate> {
	TapDetectingImageView *_imageView;
	BOOL _manualZooming;
    CGRect old;
}

@property (nonatomic,assign, getter=isManualZooming) BOOL manualZooming;

-(void) setImage:(UIImage *)image;
-(void) updateFrame:(CGRect)theFrame;

@end
