#import "BobPhotoPage.h"


@implementation BobPhotoPage

@synthesize bobImageLoadOperation = _bobImageLoadOperation, bobCache, operationQueue, touchDelegate, bobThumbnailCache;

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		_scrollView = [[BobCenteringImageScrollView alloc] initWithFrame:frame];
        _scrollView.touchDelegate = self;
		[self addSubview:_scrollView];
        
        loadingView = [[LoadingView alloc] initWithFrame:frame];
    }
    return self;
}

-(void) dealloc {
    _bobImageLoadOperation.delegate = nil;
    [loadingView release];
	[_scrollView release];
    [_bobImageLoadOperation release];
    [photoSource_ release];
    [bobCache release];
    [operationQueue release];
    
	[super dealloc];
}

-(void) setFrame:(CGRect)theFrame {
	[super setFrame:theFrame];
	[_scrollView updateFrame:theFrame];	
}


#pragma mark -
#pragma mark BobPage Methods

-(void) prepareForReuse {
    if (![self.bobImageLoadOperation isExecuting]) {
        [self.bobImageLoadOperation cancel];
    }
    self.bobImageLoadOperation.delegate = nil;
    self.bobImageLoadOperation = nil;
    [_scrollView setImage:nil];
	[self setNeedsLayout];
}

-(void) setScrollViewImage:(UIImage *) theImage {
    [loadingView removeFromSuperview];
    [_scrollView setImage:theImage];
}


#pragma mark -
#pragma mark BobPageImage Methods

-(void) setPhoto:(BobPhoto *)photo {
    if (photoSource_) {
        [photoSource_ release], photoSource_ = nil;
    }
    photoSource_ = [photo.image retain];
    UIImage *image = [bobCache objectForKey:[photoSource_ location]];
    if (image == nil) {
        if (bobThumbnailCache) {
            UIImage *thumbnail = [bobThumbnailCache objectForKey:[photo.thumbnail location]];
            if (thumbnail) {
                [_scrollView setScaledThumbnail:thumbnail];
                [self setNeedsLayout];
            }
        }
        BobImageLoadOperation *bobImageLoadOperation = [[[BobImageLoadOperation alloc] initWithPhotoSource:photoSource_] autorelease];
        bobImageLoadOperation.delegate = self;
        bobImageLoadOperation.bobCache = bobCache;
        [operationQueue addOperation:bobImageLoadOperation];
        _bobImageLoadOperation = [bobImageLoadOperation retain];
    } else {
        [loadingView removeFromSuperview];
        [_scrollView setImage:image];
    } 
}
   
-(void) loadImage:(UIImage *) i {
    [self setScrollViewImage:i];
}

-(void) bobCenteringImageScrollViewSingleClicked:(BobCenteringImageScrollView *)bobCenteringImageScrollView {
    [touchDelegate photoViewTouched:self];
}
         
@end
