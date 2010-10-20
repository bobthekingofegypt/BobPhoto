#import <Foundation/Foundation.h>

@protocol TapDetectingImageViewDelegate;


@interface TapDetectingImageView : UIImageView {
	id<TapDetectingImageViewDelegate> delegate;
    
    CGPoint tapLocation;
    BOOL multipleTouches;
}

@property (nonatomic, assign) id<TapDetectingImageViewDelegate> delegate;

@end

@protocol TapDetectingImageViewDelegate <NSObject>
@optional
- (void)tapDetectingImageView:(TapDetectingImageView *)view singleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingImageView:(TapDetectingImageView *)view doubleTapAtPoint:(CGPoint)tapPoint;
@end