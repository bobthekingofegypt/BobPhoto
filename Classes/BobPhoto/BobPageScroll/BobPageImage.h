#import <Foundation/Foundation.h>
#import "BobPage.h"
#import "BobCenteringImageScrollView.h"

@interface BobPageImage : BobPage {
	BobCenteringImageScrollView *_scrollView;
}

-(void)setImage:(UIImage *) image;

@end
