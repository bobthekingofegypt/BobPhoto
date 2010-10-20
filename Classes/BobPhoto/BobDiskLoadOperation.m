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
    //NSLog(@"TESTING");
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    //UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:location_ ofType:nil]]; //[UIImage imageNamed:location_];
    //UIImage *image = [UIImage imageNamed:location_];
    NSString *path = [[NSBundle mainBundle] pathForResource:location_ ofType:nil];
    char *filename = [path cString];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename(filename);
    
    CGImageRef image;
    if ([path hasSuffix:@".png"]) {
        image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, 
                                         kCGRenderingIntentDefault);
    } else {
        image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, 
                                         kCGRenderingIntentDefault);
    }
    
    CGDataProviderRelease(dataProvider);
    
    // make a bitmap context of a suitable size to draw to, forcing decode
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    unsigned char *imageBuffer = (unsigned char *)malloc(width*height*4);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef imageContext =
    CGBitmapContextCreate(imageBuffer, width, height, 8, width*4, colourSpace,
                          kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    CGColorSpaceRelease(colourSpace);
    
    // draw the image to the context, release it
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGImageRelease(image);
    
    // now get an image ref from the context
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    // post that off to the main thread, where you might do something like
    // [UIImage imageWithCGImage:outputImage]
    [self performSelectorOnMainThread:@selector(preloadImage:) 
                           withObject:[NSValue valueWithPointer:outputImage] waitUntilDone:YES];
    //-(void) loadImage:(NSValue *) value
    // clean up
    CGImageRelease(outputImage);
    CGContextRelease(imageContext);
    free(imageBuffer);
    
    //image_ = [image retain];
    [pool release];
}

-(void) preloadImage:(NSValue *) value  {
    CGImageRef imageRef = [value pointerValue];
    UIImage *i = [UIImage imageWithCGImage:imageRef];
    [bobCache addObject:i forKey:location_];
    [delegate loadImage:i];
}

-(void) dealloc {
    
    //NSLog(@"DEALLLLLLOOOOOOCCCCC");
    [location_ release];
    [image_ release];
    
    [super dealloc];
}

@end
