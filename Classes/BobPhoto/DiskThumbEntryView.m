#import "DiskThumbEntryView.h"


@implementation DiskThumbEntryView

@synthesize bobDiskLoadOperation = _bobDiskLoadOperation, bobCache, operationQueue;

-(id) initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor lightGrayColor];
		//imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1,1,73,73)];
        
        //[self addSubview:imageView];
    }
    return self;
}

-(void) drawRect:(CGRect)rect {
    if (!image) {
        //NSLog(@"TEST2");
        [[UIColor lightGrayColor] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, rect);
    } else {
        [image drawAtPoint:CGPointMake(1.0f,1.0f)];
    }
}

-(void) prepareForReuse {
    //NSLog(@"TEST");
    //[_bobDiskLoadOperation removeObserver:self forKeyPath:@"isFinished"];
    _bobDiskLoadOperation.delegate = nil;
    self.bobDiskLoadOperation = nil;
    [self setImage:nil];
    //imageView.image = nil;
}

-(void) setImage:(UIImage *)theImage {
	[image release];
	image = [theImage retain];
	[self setNeedsDisplay];
}

-(void) setPath:(NSString *) path {
    path_ = [path copy];
    UIImage *theImage = [bobCache objectForKey:path];
    //NSLog(@"TEST");
    if (theImage == nil) {
        //
    } else {
        [self setImage:theImage];
        //imageView.image = theImage;
        //[self setNeedsDisplay];
    } 
}

-(void) triggerDownload {
    if (image == nil) {
        BobDiskLoadOperation *bobDiskLoadOperation = [[[BobDiskLoadOperation alloc] initWithLocation:path_] autorelease];
        [bobDiskLoadOperation setDelegate:self];
        bobDiskLoadOperation.bobCache = bobCache;
        //[bobDiskLoadOperation 
        //[bobDiskLoadOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        [operationQueue addOperation:bobDiskLoadOperation];
        _bobDiskLoadOperation = [bobDiskLoadOperation retain];
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinished"]) {
        [bobCache addObject:[_bobDiskLoadOperation image] forKey:path_];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:[_bobDiskLoadOperation image] waitUntilDone:NO];
    }
}

-(void) loadImage:(UIImage *) i {
    //CGImageRef imageRef = [value pointerValue];
    //UIImage *i = [UIImage  imageWithCGImage:imageRef];
    //[bobCache addObject:i forKey:path_];
    //[image release];
	//image = [i retain];
    
    //NSTimer *timer = [NSTimer timerWithTimeInterval:0.0 target:self selector:@selector(test:) userInfo:nil repeats:NO];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //NSLog(@"TIMER");
    [self setImage:i];
}
         


-(void) dealloc {
    //[_bobDiskLoadOperation removeObserver:self forKeyPath:@"isFinished"];
    _bobDiskLoadOperation.delegate = nil;
    [_bobDiskLoadOperation release];
    [path_ release];
	[image release];
    [bobCache release];
    [operationQueue release];
	[super dealloc];
}

@end
