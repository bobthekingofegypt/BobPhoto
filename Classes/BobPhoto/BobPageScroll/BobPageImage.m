#import "BobPageImage.h"

@implementation BobPageImage

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		_scrollView = [[BobCenteringImageScrollView alloc] initWithFrame:frame];
		
		[self addSubview:_scrollView];
    }
    return self;
}

-(void) dealloc {
	[_scrollView release];
	[super dealloc];
}

-(void) setFrame:(CGRect)theFrame {
	[super setFrame:theFrame];
	[_scrollView updateFrame:theFrame];	
}


#pragma mark -
#pragma mark BobPage Methods

-(void) prepareForReuse {
	_scrollView.zoomScale = 1.0f;
	[self setNeedsLayout];
}


#pragma mark -
#pragma mark BobPageImage Methods

-(void) setImage:(UIImage *)image {
	[_scrollView setImage:image];
}

@end
