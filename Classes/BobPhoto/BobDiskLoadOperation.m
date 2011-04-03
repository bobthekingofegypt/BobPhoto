#import "BobDiskLoadOperation.h"


@implementation BobDiskLoadOperation

@synthesize image = image_, delegate, bobCache;

-(id) initWithLocation:(NSString *) location {
    self = [super init];
    if (self) {
        location_ = [location copy];
    }
    
    return self;
}

-(void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:location_ ofType:nil];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([path UTF8String]);
    
    CGImageRef image;
    if ([path hasSuffix:@".png"]) {
        image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, 
                                         kCGRenderingIntentDefault);
    } else {
        image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, 
                                         kCGRenderingIntentDefault);
    }
    
    CGDataProviderRelease(dataProvider);
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    unsigned char *imageBuffer = (unsigned char *)malloc(width*height*4);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef imageContext =
    CGBitmapContextCreate(imageBuffer, width, height, 8, width*4, colourSpace,
                          kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    CGColorSpaceRelease(colourSpace);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGImageRelease(image);
    
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    [self performSelectorOnMainThread:@selector(preloadImage:) 
                           withObject:[NSValue valueWithPointer:outputImage] waitUntilDone:YES];
    
    CGImageRelease(outputImage);
    CGContextRelease(imageContext);
    free(imageBuffer);
    
    [pool release];
}

-(void) preloadImage:(NSValue *) value  {
    CGImageRef imageRef = [value pointerValue];
    UIImage *i = [UIImage imageWithCGImage:imageRef];
    [bobCache addObject:i forKey:location_];
    [delegate loadImage:i];
}

-(void) dealloc {
    [location_ release];
    [image_ release];
    
    [super dealloc];
}

@end
