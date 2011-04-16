#import "DiskThumbEntryView.h"

@interface DiskThumbEntryView()
-(void) setImage:(UIImage *)theImage;
@end

@implementation DiskThumbEntryView

@synthesize bobDiskLoadOperation = _bobDiskLoadOperation, bobCache, operationQueue;

-(id) initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void) dealloc {
    _bobDiskLoadOperation.delegate = nil;
    [_bobDiskLoadOperation release];
    [path_ release];
	[image release];
    [bobCache release];
    [operationQueue release];
	[super dealloc];
}

#pragma mark draw methods

-(void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!image) {
        [[UIColor lightGrayColor] set];
        CGContextFillRect(context, rect);
    } else {
        [image drawAtPoint:CGPointMake(1.0f, 1.0f)];
        CGPoint addLines[] = {
            CGPointMake(0.0f, 0.0f),
            CGPointMake(rect.size.width, 0.0f),
            CGPointMake(rect.size.width, rect.size.height),
            CGPointMake(0.0f, rect.size.height),
            CGPointMake(0.0f, 0.0f)
        };
        CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
        CGContextStrokePath(context);
    }
}

#pragma mark reuse methods

-(void) prepareForReuse {
    _bobDiskLoadOperation.delegate = nil;
    self.bobDiskLoadOperation = nil;
    [self setImage:nil];
}

#pragma mark public methods

-(void) setPath:(NSString *) path {
    path_ = [path copy];
    UIImage *theImage = [bobCache objectForKey:path];
    if (theImage) {
        [self setImage:theImage];
    } 
}

-(void) triggerDownload {
    if (image == nil) {
        BobDiskLoadOperation *bobDiskLoadOperation = [[[BobDiskLoadOperation alloc] initWithLocation:path_] autorelease];
        [bobDiskLoadOperation setDelegate:self];
        bobDiskLoadOperation.bobCache = bobCache;
        [operationQueue addOperation:bobDiskLoadOperation];
        _bobDiskLoadOperation = [bobDiskLoadOperation retain];
    }
}

#pragma mark private methods

-(void) setImage:(UIImage *)theImage {
	[image release];
	image = [theImage retain];
	[self setNeedsDisplay];
}

-(void) loadImage:(UIImage *) i {
    [self setImage:i];
}

@end
