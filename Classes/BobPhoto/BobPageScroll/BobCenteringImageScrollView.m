#import "BobCenteringImageScrollView.h"


@interface BobCenteringImageScrollView (Private)
-(void) setScrollViewZoomScalesForBounds:(CGSize)boundsSize andImageSize:(CGSize)imageSize;
@end

@implementation BobCenteringImageScrollView

@synthesize manualZooming = _manualZooming, touchDelegate;

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.delegate = self;
		self.bouncesZoom = YES;
		self.clipsToBounds = YES;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		
		_imageView = [[TapDetectingImageView alloc] initWithFrame:CGRectZero];
		_imageView.delegate = self;
		_imageView.userInteractionEnabled = YES;
		_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_imageView.clipsToBounds = YES;
		
		[self addSubview:_imageView];
        
        old = CGRectZero;
	}
	return self;
}

-(void) dealloc {
	[_imageView release];
	[super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	//if a double tap zoom is happening the origin of the frame needs to be reset because of some weirdness in 3.0/3.1
	if (self.manualZooming) {
		self.frame = CGRectMake(0.0f,0.0f,self.frame.size.width, self.frame.size.height);
	}
	
	CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _imageView.frame = frameToCenter;
}

-(void) setScrollViewZoomScalesForBounds:(CGSize)boundsSize andImageSize:(CGSize)imageSize {	
    CGFloat xScale = boundsSize.width / imageSize.width; 
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = 1.0;
	
    if (minScale > maxScale) {
        minScale = maxScale;
    }
	
	self.zoomScale = 1.0f;
    self.contentSize = imageSize;
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

-(void) setImageToBoundsSize:(CGSize)boundsSize andImageSize:(CGSize)imageSize {	
    CGFloat xScale = boundsSize.width / imageSize.width; 
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
	
	self.zoomScale = 1.0f;
    self.contentSize = imageSize;
    self.maximumZoomScale = minScale;
    self.minimumZoomScale = 1.0f;
}


-(void) setScaledThumbnail:(UIImage *) image {
    thumbnail = YES;
    
    CGSize imageSize = image.size;
    _imageView.image = image;
    _imageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
	
    [self setImageToBoundsSize:self.bounds.size andImageSize:imageSize];
    self.zoomScale = self.maximumZoomScale;
    [self setNeedsLayout];
}

-(void) setImage:(UIImage *)image {
     
    if (!image) {
        _imageView.image = nil;
        _imageView.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
        self.zoomScale = 1.0f;
        self.contentSize = self.bounds.size;
        self.maximumZoomScale = 1.0f;
        self.minimumZoomScale = 1.0f;
    } else {
        if (thumbnail) {
            _imageView.image = nil;
            _imageView.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
            self.zoomScale = 1.0f;
            self.contentSize = self.bounds.size;
            self.maximumZoomScale = 1.0f;
            self.minimumZoomScale = 1.0f;
            thumbnail = NO;
        }
        CGSize imageSize = image.size;
        _imageView.image = image;
        _imageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
	
        [self setScrollViewZoomScalesForBounds:self.bounds.size andImageSize:imageSize];
        self.zoomScale = self.minimumZoomScale;
    }
}

-(void) updateFrame:(CGRect)theFrame {
    if (CGRectEqualToRect(old, theFrame)) {
        return;
    }
    
    
    if (!_imageView.image) {
        return;
    }
    old = theFrame;
    oldSize = theFrame.size;
    
    BOOL isMin = (self.zoomScale == self.minimumZoomScale);
    float oldZoomScale = self.zoomScale;
          
    if (thumbnail) {
        if (CGSizeEqualToSize(oldSize, theFrame.size)) {
            return;
        }
        self.zoomScale = 1.0f;
        _imageView.frame = CGRectMake(0.0f, 0.0f, _imageView.image.size.width, _imageView.image.size.height);
        [self setImageToBoundsSize:theFrame.size andImageSize:_imageView.image.size];
    } else {
        self.zoomScale = 1.0f;
        _imageView.frame = CGRectMake(0.0f, 0.0f, _imageView.image.size.width, _imageView.image.size.height);
        [self setScrollViewZoomScalesForBounds:theFrame.size andImageSize:_imageView.image.size];
    }
          
    if (isMin) {
        self.zoomScale = self.minimumZoomScale;
    } else {
        self.zoomScale = oldZoomScale;
    }
}


#pragma mark -
#pragma mark ScrollView Delegate methods

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	self.manualZooming = NO;
	self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);	 
}

#pragma mark -
#pragma mark TapDetectingImageView Delegate methods

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
            [touchDelegate bobCenteringImageScrollViewSingleClicked:self];
        }
    }    
    
    if (allTouchesEnded) {
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    multipleTouches = NO;
}

-(void)tapDetectingImageView:(TapDetectingImageView *)view singleTapAtPoint:(CGPoint)tapPoint {
	[touchDelegate bobCenteringImageScrollViewSingleClicked:self];
}

-(void)tapDetectingImageView:(TapDetectingImageView *)view doubleTapAtPoint:(CGPoint)tapPoint {
	float theZoomScale;
	
	if (self.zoomScale == self.maximumZoomScale) {
		theZoomScale = self.minimumZoomScale;
	} else {
		theZoomScale = self.maximumZoomScale;
	}
	
	CGRect zoomRect;
	
	zoomRect.size.height = [self frame].size.height / theZoomScale;
	zoomRect.size.width = [self frame].size.width  / theZoomScale;
	
	float x = tapPoint.x - (zoomRect.size.width  / 2.0);
	float y = tapPoint.y - (zoomRect.size.height / 2.0);
	
	zoomRect.origin.x = x;
	zoomRect.origin.y = y;
	
	self.manualZooming = YES;
	[self zoomToRect:zoomRect animated:YES];
}



@end
