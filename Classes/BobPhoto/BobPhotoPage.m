//
//  BobPhotoPage.m
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhotoPage.h"


@implementation BobPhotoPage

@synthesize bobDiskLoadOperation = _bobDiskLoadOperation, bobCache, operationQueue;

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
    //[_bobDiskLoadOperation removeObserver:self forKeyPath:@"isFinished"];
    self.bobDiskLoadOperation.delegate = nil;
    self.bobDiskLoadOperation = nil;
    [_scrollView setImage:nil];
	//_scrollView.zoomScale = 1.0f;
    //[_scrollView removeFromSuperview];
	[self setNeedsLayout];
}

-(void) setScrollViewImage:(UIImage *) theImage {
    //[_scrollView setImage:nil]; 
    [_scrollView setImage:theImage];
    //_scrollView.zoomScale = 1.0f;
    //[self addSubview:_scrollView];
    //[self setNeedsLayout];
    //_scrollView.zoomScale = 1.0f;
}


#pragma mark -
#pragma mark BobPageImage Methods

-(void) setPath:(NSString *) path {
    path_ = [path copy];
    UIImage *image = [bobCache objectForKey:path];
    if (image == nil) {
        BobDiskLoadOperation *bobDiskLoadOperation = [[[BobDiskLoadOperation alloc] initWithLocation:path] autorelease];
        //[bobDiskLoadOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        bobDiskLoadOperation.delegate = self;
        bobDiskLoadOperation.bobCache = bobCache;
        [operationQueue addOperation:bobDiskLoadOperation];
        _bobDiskLoadOperation = [bobDiskLoadOperation retain];
    } else {
        [_scrollView setImage:image];
    } 
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinished"]) {
        [bobCache addObject:[_bobDiskLoadOperation image] forKey:path_];
        [self performSelectorOnMainThread:@selector(setScrollViewImage:) withObject:[_bobDiskLoadOperation image] waitUntilDone:NO];
    }
}
   
-(void) loadImage:(UIImage *) i {
        //[image release];
	//image = [i retain];
    
    //NSTimer *timer = [NSTimer timerWithTimeInterval:0.0 target:self selector:@selector(test:) userInfo:nil repeats:NO];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //NSLog(@"TIMER");
    //[self setImage:i];
     [self setScrollViewImage:i];
}
         
@end
