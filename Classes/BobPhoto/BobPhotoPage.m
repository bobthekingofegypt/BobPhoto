#import "BobPhotoPage.h"


@implementation BobPhotoPage

@synthesize bobDiskLoadOperation = _bobDiskLoadOperation, bobCache, operationQueue, touchDelegate, bobThumbnailCache;

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		_scrollView = [[BobCenteringImageScrollView alloc] initWithFrame:frame];
        _scrollView.touchDelegate = self;
		[self addSubview:_scrollView];
        
        loadingView = [[LoadingView alloc] initWithFrame:frame];
        //[self addSubview:loadingView];
    }
    return self;
}

-(void) dealloc {
    _bobDiskLoadOperation.delegate = nil;
    [loadingView release];
	[_scrollView release];
    [_bobDiskLoadOperation release];
    [path_ release];
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
    self.bobDiskLoadOperation.delegate = nil;
    self.bobDiskLoadOperation = nil;
    [_scrollView setImage:nil];
	[self setNeedsLayout];
}

-(void) setScrollViewImage:(UIImage *) theImage {
    [loadingView removeFromSuperview];
    [_scrollView setImage:theImage];
}


#pragma mark -
#pragma mark BobPageImage Methods

-(void) setPath:(id<BobPhoto>) bobPhoto {
    path_ = [[bobPhoto imageLocation] copy];
    UIImage *image = [bobCache objectForKey:path_];
    if (image == nil) {
        if (bobThumbnailCache) {
            UIImage *thumbnail = [bobThumbnailCache objectForKey:[bobPhoto thumbnailLocation]];
            if (thumbnail) {
                [_scrollView setScaledThumbnail:thumbnail];
                [self setNeedsLayout];
            }
        }
        //[self addSubview:loadingView];
        BobDiskLoadOperation *bobDiskLoadOperation = [[[BobDiskLoadOperation alloc] initWithLocation:path_] autorelease];
        bobDiskLoadOperation.delegate = self;
        bobDiskLoadOperation.bobCache = bobCache;
        [operationQueue addOperation:bobDiskLoadOperation];
        _bobDiskLoadOperation = [bobDiskLoadOperation retain];
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
