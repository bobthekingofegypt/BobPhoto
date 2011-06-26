#import "BobImageLoadOperation.h"


@interface BobImageLoadOperation()
-(void)cache:(NSData *)imageData;
-(NSData*) getStoredImage;
@end

@implementation BobImageLoadOperation

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

-(void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CGDataProviderRef dataProvider;
    NSString *mimeType = nil;
    if ([[photoSource_ location] hasPrefix:@"http"]) {
        NSData *imageData = nil; //[self getStoredImage];
        if (imageData) {
            dataProvider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
        } else {
            NSURL *url = [NSURL URLWithString:[photoSource_ location]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
            NSError *error;
            NSURLResponse *response;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; 
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            mimeType = [response MIMEType];
            
            if ([[photoSource_ location] hasSuffix:@".gif"] || [mimeType isEqualToString:@"image/gif"]) {
                UIImage *image = [[UIImage alloc] initWithData:result];
                [self performSelectorOnMainThread:@selector(preloadImage:) 
                                       withObject:[NSValue valueWithPointer:[image CGImage]] waitUntilDone:YES];
                [image release];
                
                return;
            }
            
            dataProvider = CGDataProviderCreateWithCFData((CFDataRef)result);
            
            [self cache:result];
        }
    } else {
        dataProvider = CGDataProviderCreateWithFilename([[photoSource_ location] UTF8String]);
    }
    
    CGImageRef image;
    
    if ([[photoSource_ location] hasSuffix:@".png"] || [mimeType isEqualToString:@"image/png"]) {
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

-(void)cache:(NSData *)imageData {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
	
	NSFileManager *fileman = [[NSFileManager alloc] init];
	if (![fileman fileExistsAtPath:imagesDirectory]) {
		[fileman createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	[fileman release];
	
	NSString *withoutHTTP = [[photoSource_ location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	NSString *withoutSlash = [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:withoutSlash];
    
	[imageData writeToFile:filenameStr atomically:YES];
}


-(NSData*) getStoredImage {
	if ([photoSource_ location] == (id)[NSNull null]) return nil;
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														 NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
	NSString *withoutHTTP = [[photoSource_ location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	NSString *withoutSlash = [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:withoutSlash];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *imageData = nil;
	
	if ([fileManager fileExistsAtPath:filenameStr]) {
		imageData = [NSData dataWithContentsOfFile:filenameStr];
	}
	
	[fileManager release];
	return imageData;	
}

@end
