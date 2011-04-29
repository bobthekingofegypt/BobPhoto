#import "BobDiskLoadOperation.h"


@implementation BobDiskLoadOperation

@synthesize image = image_, delegate, bobCache;

-(id) initWithPhotoSource:(id<BobPhotoSource>) photoSource {
    self = [super init];
    if (self) {
        photoSource_ = [photoSource retain];
    }
    
    return self;
}

-(void) dealloc {
    [photoSource_ release];
    [image_ release];
    [bobCache release];
    
    [super dealloc];
}

-(NSString*) highResVersion:(NSString *)filename {
    
    NSString *path = [filename pathExtension];
    NSInteger index = [filename length] - ([path length] + 1);
    
    // We insert the "@2x" token in the string at the proper position; if no 
    // device modifier is present the token is added at the end of the string
    NSString *highDefPath = [NSString stringWithFormat:@"%@@2x%@",[filename substringToIndex:index], [filename substringFromIndex:index]];
    
    //// We possibly add the extension, if there is any extension at all
    //NSString *ext = [self pathExtension];
    return highDefPath;//[ext length]>0? [highDefPath stringByAppendingPathExtension:ext] : highDefPath;
}

-(void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    //NSString *path2 = [[NSBundle mainBundle] pathForResource:location_ ofType:nil];
    //NSString *path = [self highResVersion:path2];
    //CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([path UTF8String]);
    //NSLog(@"location %@", location_);
    CGDataProviderRef dataProvider;
    if ([[photoSource_ location] hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:[photoSource_ location]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSError *error;
        NSURLResponse *response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dataProvider = CGDataProviderCreateWithCFData((CFDataRef)result);
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[photoSource_ location] ofType:nil];
        dataProvider = CGDataProviderCreateWithFilename([path UTF8String]);
    }
    
    CGImageRef image;
    if ([[photoSource_ location] hasSuffix:@".png"]) {
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
    UIImage *i = nil;
    if ([photoSource_ retina]) {
        i = [UIImage imageWithCGImage:imageRef scale:2.0f orientation:UIImageOrientationUp];
    } else {
        i = [UIImage imageWithCGImage:imageRef];
    }
    
    [bobCache addObject:i forKey:[photoSource_ location]];
    [delegate loadImage:i];
}

@end
