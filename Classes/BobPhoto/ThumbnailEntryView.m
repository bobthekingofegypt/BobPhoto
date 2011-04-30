#import "ThumbnailEntryView.h"

@interface ThumbnailEntryView()
-(void) setImage:(UIImage *)theImage;
@end

@implementation ThumbnailEntryView

@synthesize bobImageLoadOperation = bobImageLoadOperation_, bobCache, operationQueue;

-(id) initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame andReuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void) dealloc {
    bobImageLoadOperation_.delegate = nil;
    [bobImageLoadOperation_ release];
    [photoSource_ release];
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
        NSInteger imageWidth = image.size.width;
        NSInteger imageHeight = image.size.height;
        NSInteger xPoint = (imageWidth / 2.0) - (self.frame.size.width / 2.0) ;
        NSInteger yPoint = (imageHeight / 2.0) - (self.frame.size.height / 2.0);
        
        [image drawAtPoint:CGPointMake(-xPoint, -yPoint)];
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
    if (![self.bobImageLoadOperation isExecuting]) {
        [self.bobImageLoadOperation cancel];
    }
    bobImageLoadOperation_.delegate = nil;
    self.bobImageLoadOperation = nil;
    [self setImage:nil];
}

#pragma mark public methods

-(void) setPhotoSource:(id<BobPhotoSource>) photoSource; {
    if (photoSource_) {
        [photoSource_ release], photoSource_ = nil;
    }
    photoSource_ = [photoSource retain];
    UIImage *theImage = [bobCache objectForKey:[photoSource_ location]];
    if (theImage) {
        [self setImage:theImage];
    } 
}

-(void) triggerDownload {
    if (image == nil && !bobImageLoadOperation_) {
        BobImageLoadOperation *bobImageLoadOperation = [[[BobImageLoadOperation alloc] initWithPhotoSource:photoSource_] autorelease];
        [bobImageLoadOperation setDelegate:self];
        bobImageLoadOperation.bobCache = bobCache;
        [operationQueue addOperation:bobImageLoadOperation];
        bobImageLoadOperation_ = [bobImageLoadOperation retain];
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
