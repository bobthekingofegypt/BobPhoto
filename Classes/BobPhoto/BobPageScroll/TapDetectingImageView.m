#import "TapDetectingImageView.h"

#define DOUBLE_TAP_DELAY 0.35

@interface TapDetectingImageView (Private)
- (void)handleSingleTap;
- (void)handleDoubleTap;
@end

@implementation TapDetectingImageView

@synthesize delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
    
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
        tapLocation = [touch locationInView:self];
        
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } else if([touch tapCount] == 2) {
            [self handleDoubleTap];
        }
    }    
    
    if (allTouchesEnded) {
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    multipleTouches = NO;
}

#pragma mark Private

- (void)handleSingleTap {
    if ([delegate respondsToSelector:@selector(tapDetectingImageView:singleTapAtPoint:)])
        [delegate tapDetectingImageView:self singleTapAtPoint:tapLocation];
}

- (void)handleDoubleTap {
    if ([delegate respondsToSelector:@selector(tapDetectingImageView:doubleTapAtPoint:)])
        [delegate tapDetectingImageView:self doubleTapAtPoint:tapLocation];
}

@end
